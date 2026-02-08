INSERT INTO silver.financial_flow_returns (
    source_id,
    return_id,
    original_sales_id,
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
    pn.source_id,
    pn.prihod_code                         AS return_id,
    s.sales_code                           AS original_sales_id,
    pr.odate                               AS event_dt,
    s.clients_code                         AS client_code,
    s.users_id                             AS user_id,
    pn.product_code                        AS product_id,
    pn.kol::numeric                        AS quantity,
    sp.cena::numeric                       AS sale_price,

    CASE
        WHEN sp.isskidka
            THEN pn.kol::numeric * sp.cena::numeric * s.perc::numeric / 100
        ELSE 0::numeric
    END                                     AS discount_amount,

    (pn.kol::numeric * sp.cena::numeric)
    - CASE
          WHEN sp.isskidka
              THEN pn.kol::numeric * sp.cena::numeric * s.perc::numeric / 100
          ELSE 0::numeric
      END                                   AS net_sale,

    pn.kol::numeric
    * COALESCE(
        pn.cenapost,
        sp.cena::numeric / (1 + sp.nacenka::numeric / 100)
      )                                     AS cost_amount,

    (
        (pn.kol::numeric * sp.cena::numeric)
        - CASE
              WHEN sp.isskidka
                  THEN pn.kol::numeric * sp.cena::numeric * s.perc::numeric / 100
              ELSE 0::numeric
          END
        - (
            pn.kol::numeric
            * COALESCE(
                pn.cenapost,
                sp.cena::numeric / (1 + sp.nacenka::numeric / 100)
              )
          )
    )                                       AS profit_amount,

    s.opltype                               AS payment_type_id,

    md5(concat_ws(
        '|',
        pn.source_id,
        pn.prihod_code,
        s.sales_code,
        pn.product_code,
        pn.kol,
        sp.cena,
        s.perc
    ))                                      AS record_hash,

    now()                                   AS load_dt
FROM bronze.prihod_naklad pn
JOIN bronze.prihod pr
    ON pr.prihod_code = pn.prihod_code
JOIN bronze.sales_product sp
    ON pn.sales_product_code = sp.sales_product_code
JOIN bronze.sales s
    ON s.sales_code = sp.sales_code
WHERE pr.type = 2;
