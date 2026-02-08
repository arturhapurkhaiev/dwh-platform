CREATE TABLE IF NOT EXISTS silver.products_prepared (
    source_id int NOT NULL,
    product_id int NOT NULL,
    product_name text NOT NULL,
    category_id int NOT NULL,
    sale_price numeric(24,2) NOT NULL,
    cost_price numeric(24,2) NULL,
    quantity numeric(24,4) NULL,
    is_active boolean NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now(),
    PRIMARY KEY (source_id, product_id)
);
