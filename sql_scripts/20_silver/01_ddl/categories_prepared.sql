CREATE TABLE IF NOT EXISTS silver.categories_prepared (
    source_id                int NOT NULL,
    category_id              int NOT NULL,
    parent_category_id       int NULL,
    category_name            text NOT NULL,
    parent_category_name     text NULL,
    record_hash              text NOT NULL,
    load_dt                  timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (source_id, category_id)
);
