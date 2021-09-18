package api

import (
	"context"
	"io/fs"
	stdLog "log"
	"net/http"
	"strconv"
	"time"

	"bfp/conf"
	"bfp/echologrus"
	"bfp/model"
	"github.com/go-playground/validator/v10"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	echolog "github.com/labstack/gommon/log"
	log "github.com/sirupsen/logrus"
	"golang.org/x/crypto/acme/autocert"
)

type Handler struct {
	echo  *echo.Echo
	fpRep *model.FingerprintRep
}

func NewHandler(fpRep *model.FingerprintRep) *Handler {
	return &Handler{fpRep: fpRep}
}

func (h *Handler) SetupAPI(cfg *conf.Config) {
	configureHttpServer := func(server *http.Server) {
		server.ReadTimeout = 5 * time.Second
		server.WriteTimeout = 10 * time.Second
		server.IdleTimeout = 120 * time.Second
	}

	e := echo.New()
	h.echo = e
	e.Logger = echologrus.GetEchoLogger()
	e.StdLogger = stdLog.New(log.StandardLogger().Out, "", 0)
	e.HideBanner = true
	e.HidePort = true
	configureHttpServer(e.Server)
	configureHttpServer(e.TLSServer)

	e.Validator = newValidator()
	if cfg.Production {
		e.AutoTLSManager.HostPolicy = autocert.HostWhitelist(cfg.Hosts...)
		e.AutoTLSManager.Cache = autocert.DirCache("/var/www/.cache")
	}

	// Middleware
	e.Use(middleware.BodyLimit("4M"))
	if cfg.Production {
		e.Pre(middleware.HTTPSNonWWWRedirect())

		recoverCfg := middleware.RecoverConfig{
			Skipper:           middleware.DefaultSkipper,
			StackSize:         1 << 10, // 1 KB
			DisableStackAll:   true,
			DisablePrintStack: false,
			LogLevel:          echolog.ERROR,
		}
		e.Use(middleware.RecoverWithConfig(recoverCfg))
	}
	if log.IsLevelEnabled(log.DebugLevel) {
		e.Use(middleware.Logger())
	}

	e.Use(middleware.Gzip())

	// Methods
	const apiPrefix = "/api/"
	apiGroup := e.Group(apiPrefix)

	apiGroup.POST("process_fingerprint", h.ProcessFingerprint)

	// Start
	port := ":" + strconv.Itoa(cfg.Port)
	if cfg.Production {
		go func() {
			port := ":80"
			if err := e.Start(port); err != nil {
				log.Infof("main: shutting down server %s: %s", port, err)
			}
		}()
		go func() {
			if err := e.StartAutoTLS(port); err != nil {
				log.Infof("main: shutting down server %s: %s", port, err)
			}
		}()
	} else {
		go func() {
			if err := e.Start(port); err != nil {
				log.Infof("main: shutting down server %s: %s", port, err)
			}
		}()
	}
}

func (h *Handler) SetupFrontend(fsys fs.FS) {
	fileServer := http.FileServer(http.FS(fsys))
	h.echo.GET("/*", echo.WrapHandler(fileServer))
}

func (h *Handler) Shutdown(ctx context.Context) error {
	return h.echo.Server.Shutdown(ctx)
}

func newValidator() (val *customValidator) {
	validate := validator.New()
	val = &customValidator{validator: validate}
	return val
}

type customValidator struct {
	validator *validator.Validate
}

func (cv *customValidator) Validate(i interface{}) error {
	return cv.validator.Struct(i)
}

type Error struct {
	Message string `json:"error"`
}

func (e Error) Error() string {
	return e.Message
}

func ErrorMessage(message string) Error {
	return Error{Message: message}
}

func HandleInternalError(c echo.Context, err error) error {
	return c.JSON(http.StatusInternalServerError, ErrorMessage(err.Error()))
}
