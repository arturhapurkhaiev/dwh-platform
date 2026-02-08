CREATE TABLE IF NOT EXISTS gold.dim_date (
    date_key        int PRIMARY KEY,          -- YYYYMMDD
    date_value      date NOT NULL,
    year            int NOT NULL,
    quarter         int NOT NULL,
    month           int NOT NULL,
    month_name      text NOT NULL,
    week            int NOT NULL,
    day             int NOT NULL,
    day_of_week     int NOT NULL,              -- ISO 1–7
    is_weekend      boolean NOT NULL
);
