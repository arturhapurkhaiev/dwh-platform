DROP TABLE IF EXISTS gold.fact_financial_flow;

CREATE TABLE gold.fact_financial_flow (
    fact_row_id bigserial PRIMARY KEY,
    source_id int NOT NULL,
    document_id bigint NOT NULL,
    product_id int NOT NULL,
    quantity numeric(14,4) NOT NULL,
    net_amount numeric(16,2) NOT NULL,
    discount_amount numeric(16,2) NOT NULL,
    cost_amount numeric(16,2) NOT NULL,
    profit_amount numeric(16,2) NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now()
);
