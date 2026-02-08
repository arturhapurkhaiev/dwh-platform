CREATE TABLE silver.purchase_price_history (
    source_id        int            NOT NULL,
    product_code     int            NOT NULL,
    purchase_price   numeric(19,4)   NOT NULL,

    start_date       date           NOT NULL,
    end_date         date           NULL,

    source_doc_id    int            NOT NULL, -- prihod_code
    load_date        timestamp      NOT NULL DEFAULT now(),

    PRIMARY KEY (source_id, product_code, start_date, source_doc_id)
);
