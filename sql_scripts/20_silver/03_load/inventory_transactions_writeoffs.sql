DROP TABLE IF EXISTS silver.inventory_transactions_writeoffs;
CREATE TABLE silver.inventory_transactions_writeoffs (
    source_id int NOT NULL,
    source_document_id text NOT NULL,
    event_dt timestamp NOT NULL,
    product_code int NOT NULL,
    quantity numeric(24,4) NOT NULL,
    sum_sale numeric(24,2) NOT NULL,
    sum_cost numeric(24,2) NOT NULL,
    record_hash text NOT NULL,
    load_dt timestamp NOT NULL DEFAULT now()
);

INSERT INTO silver.inventory_transactions_writeoffs
SELECT
    p.source_id,
    p.prihod_code::text,
    p.odate,
    pn.product_code,
    ROUND(-pn.kol, 4),
    ROUND(-pn.kol * pn.cena, 2),
    ROUND(-pn.kol * pn.cenapost, 2),
    md5(concat_ws('|',
        p.source_id,
        p.prihod_code,
        'writeoff',
        pn.product_code
    )),
    now()
FROM bronze.prihod p
JOIN bronze.prihod_naklad pn
  ON pn.prihod_code = p.prihod_code
WHERE p.type IN (1,3)
  AND p.prihodstate = 1;
