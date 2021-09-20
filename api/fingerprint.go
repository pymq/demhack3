package api

import (
	"fmt"
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

	resp := ProcessFingerprintResponse{}
	resp.Fingerprint.CreatedAt = time.Now()
	resp.Fingerprint.Metrics = model.Metrics{
		FrontendMetrics: req,
		BackendMetrics:  h.enrichBackendMetrics(c, req),
	}

	fps, err := h.findSimilarFps(resp.Fingerprint)
	if err != nil {
		return HandleInternalError(c, err)
	}

	if len(fps) > 0 {
		// TODO: check if fps has different userId
		resp.Fingerprint.UserId = fps[0].UserId
		resp.Fingerprint.UserIdHuman = fps[0].UserIdHuman
		resp.History, err = h.fpRep.SelectAllByID(resp.Fingerprint.UserId)
		if err != nil {
			return HandleInternalError(c, err)
		}
	} else {
		resp.History = make([]model.Fingerprint, 0)
		userIdHuman, err := h.generateUserIdHuman()
		if err != nil {
			return HandleInternalError(c, err)
		}

		resp.Fingerprint.UserId = generateUserId()
		resp.Fingerprint.UserIdHuman = userIdHuman
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

func (h *Handler) generateUserIdHuman() (string, error) {
	noun, err := h.wordsRep.GetRandomNounAndIncrementViews()
	if err != nil {
		return "", err
	}
	adj, err := h.wordsRep.GetRandomAdjective()
	if err != nil {
		return "", err
	}

	return fmt.Sprintf("%s %s", adj.Word, noun.Word), nil
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

func (h *Handler) findSimilarFps(fp model.Fingerprint) ([]model.Fingerprint, error) {
	fps, err := h.fpRep.FindByFingerprintJSHash(fp.Metrics.FingerprintJSHash)
	if err != nil {
		return nil, err
	} else if len(fps) > 0 {
		return fps, nil
	}

	fps, err = h.fpRep.FindBy(fp.Metrics.IP, fp.Metrics.Platform, fp.Metrics.Timezone)
	if err != nil {
		return nil, err
	} else if len(fps) > 0 {
		return fps, nil
	}

	return nil, nil
}
