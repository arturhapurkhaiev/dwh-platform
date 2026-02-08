INSERT INTO silver.purchase_price_history (
    source_id,
    product_code,
    purchase_price,
    start_date,
    end_date,
    source_doc_id,
    load_date
)
WITH raw_events AS (
    SELECT
        1                      AS source_id,
        pn.product_code,
        pn.cenapost            AS purchase_price,
        p.prihoddate::date     AS event_date,
        p.prihod_code          AS source_doc_id
    FROM mssql.prihod p
    JOIN mssql.prihod_naklad pn
        ON p.prihod_code = pn.prihod_code
    WHERE p.prihodstate = 1
      AND p.type = 0
      AND pn.kol > 0
),

-- 🧠 якщо кілька приходів в день — беремо з найбільшим prihod_code
deduplicated AS (
    SELECT DISTINCT ON (source_id, product_code, event_date)
        source_id,
        product_code,
        purchase_price,
        event_date,
        source_doc_id
    FROM raw_events
    ORDER BY
        source_id,
        product_code,
        event_date,
        source_doc_id DESC
),

scd AS (
    SELECT
        *,
        LEAD(event_date) OVER (
            PARTITION BY source_id, product_code
            ORDER BY event_date
        ) AS end_date
    FROM deduplicated
)

SELECT
    source_id,
    product_code,
    purchase_price,
    event_date AS start_date,
    end_date,
    source_doc_id,
    now()
FROM scd;
