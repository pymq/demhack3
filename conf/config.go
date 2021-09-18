package conf

import (
	"encoding/json"
	"io/ioutil"
	"os"
)

const (
	DefaultConfigPath = "config.json"
	ConfigEnvKey      = "BFP_CONFIG"
)

type Config struct {
	Port               int
	Production         bool
	Hosts              []string
	LogLevel           string
	DBConnectionString string
}

func ReadConfig() (*Config, error) {
	configPath := CalcConfigPath()
	data, err := ioutil.ReadFile(configPath)
	if err != nil {
		return nil, err
	}
	conf := Config{}
	err = json.Unmarshal(data, &conf)
	if err != nil {
		return nil, err
	}

	return &conf, nil
}

func CalcConfigPath() string {
	configPath := DefaultConfigPath
	if envPath := os.Getenv(ConfigEnvKey); envPath != "" {
		configPath = envPath
	}

	return configPath
}
