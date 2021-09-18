package main

import (
	"context"
	"embed"
	"io/fs"
	"os"
	"os/signal"
	"time"

	"bfp/api"
	"bfp/conf"
	"bfp/echologrus"
	log "github.com/sirupsen/logrus"
)

// @title BFP API
// @version 1.0
// @description BFP API

// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html

// @BasePath /api/

// go get -u github.com/swaggo/swag/cmd/swag
//go:generate swag init --parseDependency

//go:embed static
var frontendStatic embed.FS

func FrontendStatic() fs.FS {
	fsys, err := fs.Sub(frontendStatic, "static")
	if err != nil {
		panic(err)
	}
	return fsys
}

func main() {
	cfg, err := conf.ReadConfig()
	if err != nil {
		log.Fatalf("error loading config file: %s", err)
	}
	initLogger(cfg.LogLevel)

	handler := api.NewHandler()
	handler.SetupAPI(cfg)
	handler.SetupFrontend(FrontendStatic())

	quit := make(chan os.Signal, 2)
	signal.Notify(quit, os.Interrupt)
	<-quit
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := handler.Shutdown(ctx); err != nil {
		log.Errorf("main: shutdown http server: %s", err)
	}
}

func initLogger(level string) {
	log.SetFormatter(&log.TextFormatter{})
	log.SetOutput(os.Stdout)
	log.SetLevel(log.DebugLevel)
	lvl, err := log.ParseLevel(level)
	if err != nil {
		log.Warnf("invalid log level %s", level)
	}
	log.SetLevel(lvl)

	echologrus.Logger = log.StandardLogger()
}
