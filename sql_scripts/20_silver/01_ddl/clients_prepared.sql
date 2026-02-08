CREATE TABLE IF NOT EXISTS silver.clients_prepared (
    source_id int NOT NULL,
    client_code int NOT NULL,
    client_name text NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (source_id, client_code)
);
