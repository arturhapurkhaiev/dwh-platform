CREATE TABLE IF NOT EXISTS silver.documents (
    source_id int NOT NULL,
    document_type text NOT NULL,
    original_document_id text NOT NULL,
    original_table text NOT NULL,
    event_dt timestamp NOT NULL,
    user_id int NOT NULL,
    business_entity_type text NOT NULL,          -- client | supplier
    original_business_entity_id int NOT NULL,    -- clients_code | postav_code
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now()
);

