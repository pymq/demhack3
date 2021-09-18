package model

import (
	"context"
	"time"

	"github.com/go-pg/pg/v10"
	log "github.com/sirupsen/logrus"
)

type logQueryHook struct {
}

func (hook logQueryHook) BeforeQuery(ctx context.Context, _ *pg.QueryEvent) (context.Context, error) {
	return ctx, nil
}

func (hook logQueryHook) AfterQuery(_ context.Context, q *pg.QueryEvent) error {
	// for debug purposes
	const logAll = false
	formattedQuery, err := q.FormattedQuery()
	if err != nil {
		return err
	}

	if q.Err != nil {
		log.WithField("elapsed_time", time.Since(q.StartTime)).
			WithError(q.Err).
			WithField("query", string(formattedQuery)).
			Error("error executing query")
	} else if logAll {
		log.WithField("elapsed_time", time.Since(q.StartTime)).
			WithField("query", string(formattedQuery)).
			Infof("executing query")
	}

	return nil
}

func newLogQueryHook() pg.QueryHook {
	return logQueryHook{}
}
