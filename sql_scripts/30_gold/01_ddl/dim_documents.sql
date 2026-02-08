CREATE TABLE IF NOT EXISTS gold.dim_documents (
    document_id BIGSERIAL PRIMARY KEY,
    source_id INT NOT NULL,
    document_type TEXT NOT NULL,
    original_document_id TEXT NOT NULL,
    original_table TEXT NOT NULL,
    event_dt TIMESTAMP NOT NULL,
    user_id INT,
    business_entity_id BIGINT,
    record_hash TEXT NOT NULL,
    load_dt TIMESTAMP NOT NULL DEFAULT now(),
    UNIQUE (source_id, original_table, original_document_id)
);
