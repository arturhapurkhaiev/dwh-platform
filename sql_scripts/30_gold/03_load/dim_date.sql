INSERT INTO gold.dim_date (
    date_key,
    date_value,
    year,
    quarter,
    month,
    month_name,
    week,
    day,
    day_of_week,
    is_weekend
)
SELECT
    EXTRACT(YEAR  FROM d)::int * 10000
  + EXTRACT(MONTH FROM d)::int * 100
  + EXTRACT(DAY   FROM d)::int        AS date_key,
    d                               AS date_value,
    EXTRACT(YEAR    FROM d)::int      AS year,
    EXTRACT(QUARTER FROM d)::int      AS quarter,
    EXTRACT(MONTH   FROM d)::int      AS month,
    TO_CHAR(d, 'Month')               AS month_name,
    EXTRACT(WEEK    FROM d)::int      AS week,
    EXTRACT(DAY     FROM d)::int      AS day,
    EXTRACT(ISODOW  FROM d)::int      AS day_of_week,
    EXTRACT(ISODOW  FROM d)::int IN (6,7) AS is_weekend
FROM generate_series(
    DATE '2010-01-01',
    DATE '2035-12-31',
    INTERVAL '1 day'
) AS g(d);
