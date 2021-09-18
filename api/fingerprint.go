package api

import (
	"net"
	"net/http"
	"sort"
	"time"

	"bfp/model"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
	"github.com/oschwald/geoip2-golang"
)

type ProcessFingerprintResponse struct {
	Fingerprint model.Fingerprint
	History     []model.Fingerprint
}

// @Summary Process fingerprint
// @Accept json
// @Produce json
// @Param body body model.FrontendMetrics true "Params"
// @Success 200 {object} ProcessFingerprintResponse
// @Failure 400 {object} api.Error
// @Failure 500 {object} api.Error
// @Router /process_fingerprint [POST]
func (h *Handler) ProcessFingerprint(c echo.Context) (err error) {
	req := model.FrontendMetrics{}
	err = c.Bind(&req)
	if err != nil {
		return c.JSON(http.StatusBadRequest, ErrorMessage(err.Error()))
	}
	if err = c.Validate(req); err != nil {
		return c.JSON(http.StatusBadRequest, ErrorMessage(err.Error()))
	}

	fps, err := h.fpRep.FindByFingerprintJSHash(req.FingerprintJSHash)
	if err != nil {
		return HandleInternalError(c, err)
	}

	resp := ProcessFingerprintResponse{}

	if len(fps) > 0 {
		resp.History = fps
		resp.Fingerprint = model.Fingerprint{
			UserId:      fps[0].UserId,
			UserIdHuman: fps[0].UserIdHuman,
		}
	} else {
		resp.History = make([]model.Fingerprint, 0)
		userIdHuman, err := generateUserIdHuman()
		if err != nil {
			return HandleInternalError(c, err)
		}

		resp.Fingerprint = model.Fingerprint{
			UserId:      generateUserId(),
			UserIdHuman: userIdHuman,
		}
	}

	resp.Fingerprint.CreatedAt = time.Now()
	resp.Fingerprint.Metrics = model.Metrics{
		FrontendMetrics: req,
		BackendMetrics:  h.enrichBackendMetrics(c, req),
	}

	sort.Slice(resp.History, func(i, j int) bool {
		return resp.History[i].CreatedAt.After(resp.History[j].CreatedAt)
	})

	err = h.fpRep.InsertFp(resp.Fingerprint)
	if err != nil {
		return HandleInternalError(c, err)
	}

	return c.JSON(http.StatusOK, resp)
}

func (h *Handler) enrichBackendMetrics(c echo.Context, front model.FrontendMetrics) model.BackendMetrics {
	ipStr := c.RealIP()
	ipNet := net.ParseIP(ipStr)
	backend := model.BackendMetrics{
		IP: ipStr,
	}

	anonymous, err := h.geoDb.AnonymousIP(ipNet)
	if err == nil {
		backend.Anonymity.IsAnonymous = anonymous.IsAnonymous
		backend.Anonymity.IsTorExitNode = anonymous.IsTorExitNode
		backend.Anonymity.IsAnonymousVPN = anonymous.IsAnonymousVPN
		backend.Anonymity.IsPublicProxy = anonymous.IsPublicProxy
	}

	city, err := h.geoDb.City(ipNet)
	if err == nil {
		backend.Location.CountryISO = findCountryISO(city)
		backend.Location.Lat = city.Location.Latitude
		backend.Location.Long = city.Location.Longitude
		backend.Location.Country = findLocalizedName(city.Country.Names)
		backend.Location.City = findLocalizedName(city.City.Names)
	}

	country, err := h.geoDb.Country(ipNet)
	if err == nil && backend.Location.Country == "" {
		backend.Location.Country = findLocalizedName(country.Country.Names)
	}

	return backend
}

func generateUserId() string {
	return uuid.New().String()
}

func generateUserIdHuman() (string, error) {
	// TODO: implement real human user id
	return generateUserId(), nil
}

func findCountryISO(record *geoip2.City) string {
	if record.Country.IsoCode != "" {
		return record.Country.IsoCode
	}
	if record.RegisteredCountry.IsoCode != "" {
		return record.RegisteredCountry.IsoCode
	}
	if record.RepresentedCountry.IsoCode != "" {
		return record.RepresentedCountry.IsoCode
	}
	return ""
}

func findLocalizedName(record map[string]string) string {
	keys := []string{"ru", "ru-RU", "en", "en-US"}
	for _, name := range keys {
		val, ok := record[name]
		if ok {
			return val
		}
	}
	// take first
	for _, val := range record {
		return val
	}

	return ""
}
