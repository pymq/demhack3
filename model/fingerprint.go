package model

import (
	"fmt"

	"github.com/go-pg/pg/v10"
)

func NewDB(connectionURL string) (*pg.DB, error) {
	opt, err := pg.ParseURL(connectionURL)
	if err != nil {
		return nil, fmt.Errorf("parsing connection string: %v", err)
	}
	db := pg.Connect(opt)
	db.AddQueryHook(newLogQueryHook())

	return db, nil
}

type FingerprintRep struct {
	db *pg.DB
}

func NewFingerprint(db *pg.DB) *FingerprintRep {
	return &FingerprintRep{db: db}
}

func (fr *FingerprintRep) FindByFingerprintJSHash(hashStr string) ([]Fingerprint, error) {
	var fps []Fingerprint
	err := fr.db.Model(&fps).Where(fmt.Sprintf(`metrics -> 'fingerprintJSHash' = '"%s"'`, hashStr)).Select()

	return fps, err
}

func (fr *FingerprintRep) FindBy(ip, platform, timezone string) ([]Fingerprint, error) {
	var fps []Fingerprint
	err := fr.db.Model(&fps).
		Where(fmt.Sprintf(`metrics -> 'IP' = '"%s"'`, ip)).
		Where(fmt.Sprintf(`metrics -> 'platform' = '"%s"'`, platform)).
		Where(fmt.Sprintf(`metrics -> 'timezone' = '"%s"'`, timezone)).
		Select()

	return fps, err
}

func (fr *FingerprintRep) InsertFp(fp Fingerprint) error {
	_, err := fr.db.Model(&fp).Insert()
	return err
}
