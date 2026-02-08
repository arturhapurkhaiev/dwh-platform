CREATE TABLE IF NOT EXISTS gold.dim_products (
    source_id      int     NOT NULL,
    product_id     int     NOT NULL,
    product_name   text    NOT NULL,
    category_id    int     NOT NULL,
    record_hash    text    NOT NULL,
    load_dt        timestamp NOT NULL DEFAULT now(),
    CONSTRAINT pk_dim_products PRIMARY KEY (source_id, product_id)
);
