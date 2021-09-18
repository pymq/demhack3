package model

import (
	"fmt"

	"github.com/go-pg/pg/v10"
)

type FingerprintRep struct {
	db *pg.DB
}

func NewFingerprint(connectionURL string) (*FingerprintRep, error) {
	opt, err := pg.ParseURL(connectionURL)
	if err != nil {
		return nil, fmt.Errorf("parsing connection string: %v", err)
	}
	db := pg.Connect(opt)
	db.AddQueryHook(newLogQueryHook())

	return &FingerprintRep{db: db}, nil
}

func (fr *FingerprintRep) FindByFingerprintJSHash(hashStr string) ([]Fingerprint, error) {
	var fps []Fingerprint
	err := fr.db.Model(&fps).Where(fmt.Sprintf(`metrics -> 'fingerprintJSHash' = '"%s"'`, hashStr)).Select()

	return fps, err
}

func (fr *FingerprintRep) InsertFp(fp Fingerprint) error {
	_, err := fr.db.Model(&fp).Insert()
	return err
}
