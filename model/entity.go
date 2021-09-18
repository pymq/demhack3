package model

import (
	"time"
)

type Fingerprint struct {
	//nolint
	tableName   struct{} `pg:"bfp.fingerprint" json:"-"`
	Id          int64    `json:"-"`
	UserId      string
	UserIdHuman string // TODO
	Metrics     Metrics
	CreatedAt   time.Time
}

type Metrics struct {
	FrontendMetrics
}

type FrontendMetrics struct {
	Fonts               []string        `json:"fonts"`
	DomBlockers         interface{}     `json:"domBlockers"` // TODO
	FontPreferences     FontPreferences `json:"fontPreferences"`
	Audio               float64         `json:"audio"`
	ScreenFrame         []int           `json:"screenFrame"`
	OsCPU               interface{}     `json:"osCpu"` // TODO
	Languages           []string        `json:"languages"`
	ColorDepth          int             `json:"colorDepth"`
	DeviceMemory        int             `json:"deviceMemory"`
	ScreenResolution    []int           `json:"screenResolution"`
	HardwareConcurrency int             `json:"hardwareConcurrency"`
	Timezone            string          `json:"timezone"`
	SessionStorage      bool            `json:"sessionStorage"`
	LocalStorage        bool            `json:"localStorage"`
	IndexedDB           bool            `json:"indexedDB"`
	OpenDatabase        bool            `json:"openDatabase"`
	CPUClass            interface{}     `json:"cpuClass"` // TODO
	Platform            string          `json:"platform"`
	Plugins             []Plugins       `json:"plugins"`
	Canvas              Canvas          `json:"canvas"`
	TouchSupport        TouchSupport    `json:"touchSupport"`
	Vendor              string          `json:"vendor"`
	VendorFlavors       []string        `json:"vendorFlavors"`
	CookiesEnabled      bool            `json:"cookiesEnabled"`
	ColorGamut          string          `json:"colorGamut"`
	InvertedColors      interface{}     `json:"invertedColors"` // TODO
	ForcedColors        bool            `json:"forcedColors"`
	Monochrome          int             `json:"monochrome"`
	Contrast            interface{}     `json:"contrast"` // TODO
	ReducedMotion       bool            `json:"reducedMotion"`
	Hdr                 interface{}     `json:"hdr"` // TODO
	Math                Math            `json:"math"`
	FingerprintJSHash   string          `json:"fingerprintJSHash"`
	Apps                []DesktopApp    `json:"apps"`
}

type FontPreferences struct {
	Default float64 `json:"default"`
	Apple   float64 `json:"apple"`
	Serif   float64 `json:"serif"`
	Sans    float64 `json:"sans"`
	Mono    float64 `json:"mono"`
	Min     float64 `json:"min"`
	System  float64 `json:"system"`
}
type MimeTypes struct {
	Type     string `json:"type"`
	Suffixes string `json:"suffixes"`
}
type Plugins struct {
	Name        string      `json:"name"`
	Description string      `json:"description"`
	MimeTypes   []MimeTypes `json:"mimeTypes"`
}
type Canvas struct {
	Winding  bool   `json:"winding"`
	Geometry string `json:"geometry"`
	Text     string `json:"text"`
}
type TouchSupport struct {
	MaxTouchPoints int  `json:"maxTouchPoints"`
	TouchEvent     bool `json:"touchEvent"`
	TouchStart     bool `json:"touchStart"`
}
type Math struct {
	Acos    float64 `json:"acos"`
	Acosh   float64 `json:"acosh"`
	AcoshPf float64 `json:"acoshPf"`
	Asin    float64 `json:"asin"`
	Asinh   float64 `json:"asinh"`
	AsinhPf float64 `json:"asinhPf"`
	Atanh   float64 `json:"atanh"`
	AtanhPf float64 `json:"atanhPf"`
	Atan    float64 `json:"atan"`
	Sin     float64 `json:"sin"`
	Sinh    float64 `json:"sinh"`
	SinhPf  float64 `json:"sinhPf"`
	Cos     float64 `json:"cos"`
	Cosh    float64 `json:"cosh"`
	CoshPf  float64 `json:"coshPf"`
	Tan     float64 `json:"tan"`
	Tanh    float64 `json:"tanh"`
	TanhPf  float64 `json:"tanhPf"`
	Exp     float64 `json:"exp"`
	Expm1   float64 `json:"expm1"`
	Expm1Pf float64 `json:"expm1Pf"`
	Log1P   float64 `json:"log1p"`
	Log1PPf float64 `json:"log1pPf"`
	PowPI   float64 `json:"powPI"`
}

type DesktopApp struct {
	App    string `json:"app"`
	Status bool   `json:"status"`
}
