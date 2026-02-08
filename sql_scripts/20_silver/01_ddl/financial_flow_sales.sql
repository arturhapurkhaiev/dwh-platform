CREATE TABLE IF NOT EXISTS silver.financial_flow_sales (
    source_id        int            NOT NULL,
    sales_id         int            NOT NULL,
    event_dt         timestamp      NOT NULL,
    client_code      int            NOT NULL,
    user_id          int            NOT NULL,
    product_id       int            NOT NULL,
    quantity         numeric(14,4)  NOT NULL,
    sale_price       numeric(14,2)  NOT NULL,
    discount_amount  numeric(14,2)  NOT NULL,
    net_sale         numeric(14,2)  NOT NULL,
    cost_amount      numeric(14,2)  NOT NULL,
    profit_amount    numeric(14,2)  NOT NULL,
    payment_type_id  int            NOT NULL,
    record_hash      text           NOT NULL,
    load_dt          timestamp      NOT NULL
);
