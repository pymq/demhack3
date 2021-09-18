CREATE SCHEMA if NOT EXISTS bfp;

create table bfp.fingerprint
(
    id            serial8      NOT NULL PRIMARY KEY,
    user_id       varchar(255) NOT NULL,
    user_id_human text         NOT NULL,
    metrics       jsonb        NOT NULL DEFAULT '{}',
    created_at    timestamp    NOT NULL DEFAULT (NOW() at time zone 'utc')
);

CREATE INDEX idx_fingerprint__user_id ON bfp.fingerprint USING btree (user_id);
CREATE INDEX idx_fingerprint__metrics ON bfp.fingerprint USING gin (metrics);

