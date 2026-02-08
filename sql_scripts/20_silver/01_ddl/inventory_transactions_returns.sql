DROP TABLE IF EXISTS silver.inventory_transactions_returns;
CREATE TABLE silver.inventory_transactions_returns (
    source_id           int             NOT NULL,
    source_document_id  text            NOT NULL,   -- prihod_code (return)
    event_dt            timestamp       NOT NULL,
    product_code        int             NOT NULL,
    quantity            numeric(24,4)   NOT NULL,
    sale_price          numeric(24,2)   NOT NULL,
    cost_price          numeric(24,2)   NOT NULL,
    sum_sale            numeric(24,2)   NOT NULL,
    sum_cost            numeric(24,2)   NOT NULL,
    record_hash         text            NOT NULL,
    load_dt             timestamp       NOT NULL DEFAULT now()
);
