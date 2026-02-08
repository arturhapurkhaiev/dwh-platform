CREATE TABLE IF NOT EXISTS gold.dim_users (
    source_id    int    NOT NULL,
    user_id      int    NOT NULL,
    user_name    text   NOT NULL,
    record_hash  text   NOT NULL,
    load_dt      timestamp NOT NULL DEFAULT now(),
    CONSTRAINT pk_dim_users PRIMARY KEY (source_id, user_id)
);
