INSERT INTO silver.sale_price_history (
    source_id,
    product_code,
    sale_price,
    start_date,
    end_date,
    source_doc_type,
    source_doc_id,
    load_date
)
WITH raw_events AS (

    -- 🔹 Продажна ціна з приходів
    SELECT
        1                      AS source_id,
        pn.product_code,
        pn.cena                AS sale_price,
        p.prihoddate::date     AS event_date,
        'prihod'               AS source_doc_type,
        p.prihod_code          AS source_doc_id
    FROM mssql.prihod p
    JOIN mssql.prihod_naklad pn
        ON p.prihod_code = pn.prihod_code
    WHERE p.prihodstate = 1
      AND p.type = 0
      AND pn.kol > 0

    UNION ALL

    -- 🔹 Продажна ціна з переоцінок
    SELECT
        1                      AS source_id,
        pp.product_code,
        pp.new_cena            AS sale_price,
        per.pdate::date        AS event_date,
        'pereocenka'           AS source_doc_type,
        per.pereocenka_code    AS source_doc_id
    FROM mssql.pereocenka per
    JOIN mssql.pereocenka_product pp
        ON per.pereocenka_code = pp.pereocenka_code
    WHERE pp.kolvo > 0
),

-- 🧠 якщо в один день кілька подій — беремо з найбільшим ID
deduplicated AS (
    SELECT DISTINCT ON (source_id, product_code, event_date)
        source_id,
        product_code,
        sale_price,
        event_date,
        source_doc_type,
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
    sale_price,
    event_date    AS start_date,
    end_date,
    source_doc_type,
    source_doc_id,
    now()
FROM scd;
