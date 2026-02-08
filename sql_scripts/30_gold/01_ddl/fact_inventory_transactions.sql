DROP TABLE IF EXISTS gold.fact_inventory_transactions;
CREATE TABLE gold.fact_inventory_transactions (
    source_id     int            NOT NULL,
    document_id   bigint         NOT NULL,
    product_id    int            NOT NULL,
    quantity      numeric(24,4)  NOT NULL,
    sale_amount   numeric(24,2)  NOT NULL,
    cost_amount   numeric(24,2)  NOT NULL,
    record_hash   text           NOT NULL,
    load_dt       timestamp      NOT NULL DEFAULT now()
);

