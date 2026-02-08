INSERT INTO bronze.pereocenka (
    source_id,
    pereocenka_code,
    pdate,
    users_code,
    psumma,
    other,
    optpsumma,
    postavsumma,
    load_dt
)
SELECT
    1 AS source_id,
    pereocenka_code,
    pdate,
    users_code,
    psumma,
    other,
    optpsumma,
    postavsumma,
    now() AS load_dt
FROM mssql.pereocenka;
