CREATE TABLE IF NOT EXISTS gold.dim_categories (
    source_id            int NOT NULL,
    category_id          int NOT NULL,        -- business key (з MiniSoft)
    parent_category_id   int NULL,
    category_name        text NOT NULL,
    record_hash          text NOT NULL,
    load_dt              timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (source_id, category_id)
);

