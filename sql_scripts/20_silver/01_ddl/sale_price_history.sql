CREATE TABLE silver.sale_price_history (
    source_id        int            NOT NULL,
    product_code     int            NOT NULL,
    sale_price       numeric(19,4)   NOT NULL,

    start_date       date           NOT NULL,
    end_date         date           NULL,

    source_doc_type  text           NOT NULL, -- 'prihod' | 'pereocenka'
    source_doc_id    int            NOT NULL, -- prihod_code / pereocenka_code

    load_date        timestamp      NOT NULL DEFAULT now(),

    PRIMARY KEY (source_id, product_code, start_date, source_doc_id)
);
