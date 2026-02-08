CREATE TABLE silver.users_prepared (
    user_id     INTEGER NOT NULL,
    user_name   TEXT,
    source_id   INTEGER NOT NULL,
    record_hash TEXT,
    CONSTRAINT pk_users_prepared PRIMARY KEY (source_id, user_id)
);
