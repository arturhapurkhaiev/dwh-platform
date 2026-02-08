CREATE TABLE IF NOT EXISTS gold.dim_business_entity (
    business_entity_id       BIGSERIAL PRIMARY KEY,
    source_id                int NOT NULL,
    business_entity_type     text NOT NULL,   -- client | supplier
    original_entity_id       int NOT NULL,    -- clients_code | postav_code
    business_entity_name     text NOT NULL,
    record_hash              text NOT NULL,
    load_dt                  timestamp NOT NULL DEFAULT now(),
    UNIQUE (source_id, business_entity_type, original_entity_id)
);
