CREATE TABLE IF NOT EXISTS silver.postavschiki_prepared (
    source_id int NOT NULL,
    postav_code int NOT NULL,
    postav_name text NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (source_id, postav_code)
);
