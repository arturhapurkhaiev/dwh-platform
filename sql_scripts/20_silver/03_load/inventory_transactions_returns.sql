DROP TABLE IF EXISTS silver.inventory_transactions_returns;
CREATE TABLE silver.inventory_transactions_returns (
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

INSERT INTO silver.inventory_transactions_returns
SELECT
    p.source_id,
    p.prihod_code::text,
    p.odate,
    pn.product_code,
    ROUND(pn.kol, 4),
    ROUND(pn.kol * sp.cena, 2),
    ROUND(
        pn.kol * COALESCE(
            pn.cenapost,
            ROUND(
                sp.cena::numeric / (1 + sp.nacenka::numeric / 100),
                2
            )
        ),
        2
    ),
    md5(concat_ws('|',
        p.source_id,
        p.prihod_code,
        'return',
        pn.product_code
    )),
    now()
FROM bronze.prihod p
JOIN bronze.prihod_naklad pn
  ON pn.prihod_code = p.prihod_code
JOIN bronze.sales_product sp
  ON sp.sales_product_code = pn.sales_product_code
WHERE p.type = 2;
