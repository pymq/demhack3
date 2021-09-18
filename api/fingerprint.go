package api

import (
	"net/http"
	"sort"
	"time"

	"bfp/model"
	"github.com/google/uuid"
	"github.com/labstack/echo/v4"
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
			Metrics: model.Metrics{
				FrontendMetrics: req,
			},
			CreatedAt: time.Now(),
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
			Metrics: model.Metrics{
				FrontendMetrics: req,
			},
			CreatedAt: time.Now(),
		}
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

func generateUserId() string {
	return uuid.New().String()
}

func generateUserIdHuman() (string, error) {
	// TODO: implement real human user id
	return generateUserId(), nil
}
