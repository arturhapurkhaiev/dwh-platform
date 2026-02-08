-- =========================
-- FDW INIT (TECHNICAL LAYER)
-- =========================

SET client_min_messages TO WARNING;

CREATE EXTENSION IF NOT EXISTS tds_fdw;

CREATE SCHEMA IF NOT EXISTS mssql;

CREATE SERVER IF NOT EXISTS minisoft_mssql
FOREIGN DATA WRAPPER tds_fdw
OPTIONS (
  servername '10.0.1.43',
  port '1433',
  database 'minisoft2',
  tds_version '7.4'
);

CREATE USER MAPPING IF NOT EXISTS FOR dwh
SERVER minisoft_mssql
OPTIONS (
  username 'dwh_extractor',
  password 'dwh_extractor'
);
