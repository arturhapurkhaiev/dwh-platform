INSERT INTO silver.financial_flow_sales (
    source_id,
    sales_id,
    event_dt,
    client_code,
    user_id,
    product_id,
    quantity,
    sale_price,
    discount_amount,
    net_sale,
    cost_amount,
    profit_amount,
    payment_type_id,
    record_hash,
    load_dt
)
SELECT
    s.source_id,
    s.sales_code                           AS sales_id,
    s.dates                                AS event_dt,
    s.clients_code                         AS client_code,
    s.users_id                             AS user_id,
    sp.product_code                        AS product_id,
    sp.colvo::numeric                      AS quantity,
    sp.cena::numeric                       AS sale_price,

    /* discount */
    CASE
        WHEN sp.isskidka
            THEN sp.sumvsego::numeric * s.perc::numeric / 100
        ELSE 0::numeric
    END                                    AS discount_amount,

    /* net */
    sp.sumvsego::numeric
      - CASE
            WHEN sp.isskidka
                THEN sp.sumvsego::numeric * s.perc::numeric / 100
            ELSE 0::numeric
        END                                 AS net_sale,

    /* cost */
    (sp.cena::numeric / (1 + sp.nacenka::numeric / 100))
        * sp.colvo::numeric                AS cost_amount,

    /* profit */
    (
        sp.sumvsego::numeric
        - CASE
              WHEN sp.isskidka
                  THEN sp.sumvsego::numeric * s.perc::numeric / 100
              ELSE 0::numeric
          END
    )
    - (
        (sp.cena::numeric / (1 + sp.nacenka::numeric / 100))
        * sp.colvo::numeric
      )                                    AS profit_amount,

    s.opltype                              AS payment_type_id,

    md5(concat_ws(
        '|',
        s.source_id,
        s.sales_code,
        sp.sales_product_code,
        sp.product_code,
        sp.colvo,
        sp.cena,
        s.perc,
        s.opltype
    ))                                     AS record_hash,

    now()                                  AS load_dt
FROM bronze.sales s
JOIN bronze.sales_product sp
    ON sp.sales_code = s.sales_code
WHERE s.deleted = false;
