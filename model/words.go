package model

import (
	"math/rand"

	"github.com/go-pg/pg/v10"
)

type Noun struct {
	//nolint
	tableName  struct{} `pg:"namegen.nouns" json:"-"`
	Id         int64    `json:"-"`
	Word       string
	Code       int
	CodeParent int
	Gender     string
	Wcase      string
	Soul       bool
	Views      string `pg:",use_zero"`
}

type Adjective struct {
	//nolint
	tableName    struct{} `pg:"namegen.adjectives" json:"-"`
	Id           int64    `json:"-"`
	Word         string
	Code         int
	Unchangeable bool
	Views        string `pg:",use_zero"`
}

var (
	noun      Noun
	adjective Adjective
)

type WordsRepository interface {
	GetRandomNounAndIncrementViews() (Noun, error)
	GetRandomAdjective() (Adjective, error)
}

type wordsRepository struct {
	db              *pg.DB
	nounsCount      int
	adjectivesCount int
}

func NewWordsRepository(db *pg.DB) (WordsRepository, error) {
	wordsRep := wordsRepository{db: db}
	nounsCount, err := wordsRep.getNounsCount()
	if err != nil {
		return nil, err
	}
	adjectivesCount, err := wordsRep.getAdjectivesCount()
	if err != nil {
		return nil, err
	}
	wordsRep.nounsCount = nounsCount
	wordsRep.adjectivesCount = adjectivesCount
	return &wordsRep, nil
}

func (r *wordsRepository) getNounsCount() (int, error) {
	return r.db.Model(&noun).Count()
}

func (r *wordsRepository) getAdjectivesCount() (int, error) {
	return r.db.Model(&adjective).Count()
}

func (r *wordsRepository) GetRandomNounAndIncrementViews() (Noun, error) {
	randNumb := rand.Intn(r.nounsCount) + 1
	randomNoun := Noun{}

	_, err := r.db.Model(&randomNoun).
		Set("views = noun.views + 1").
		Where("id = ?", randNumb).
		Returning("*").
		Update(&randomNoun)

	return randomNoun, err
}

func (r *wordsRepository) GetRandomAdjective() (Adjective, error) {
	randNumb := rand.Intn(r.adjectivesCount) + 1
	randomAdj := Adjective{}

	_, err := r.db.Model(&randomAdj).
		Set("views = adjective.views + 1").
		Where("id = ?", randNumb).
		Returning("*").
		Update(&randomAdj)

	return randomAdj, err
}
