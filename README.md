# 🧱 DWH Platform for MiniSoft Commerce

A reproducible analytical Data Warehouse (DWH) platform for **MiniSoft Commerce** (MS SQL Server 2005).

---

## 🌍 Language / Мова
* [English](#english-version)
* [Українська](#ukrainian-version)

---

<a name="english-version"></a>
## English Version

### 🎯 Project Goal
* Decouple analytics from the OLTP system
* Build a stable analytical DWH on PostgreSQL
* Ensure full reproducibility on a new server
* Use a SQL-first approach without imperative ETL

### 🧭 Architecture Overview
```text
MS SQL Server 2005 (MiniSoft, private network)
        │
        │  tds_fdw (via WireGuard VPN)
        ▼
PostgreSQL 16 (DWH)
│
├── mssql   — foreign tables (source contract)
├── bronze  — raw data copy
├── silver  — prepared and cleaned data
└── gold    — analytical model (facts / dimensions)
```
🧩 Core Principles
* FDW instead of ETL — direct reads from MS SQL.

* Layered architecture: bronze → silver → gold.

* Idempotency — safe re-runs at any time.

* Infrastructure as Code — Docker + SQL.

🔐 Source Access (WireGuard VPN)
[!IMPORTANT] The MS SQL database is located inside a private network and is accessible only via WireGuard VPN.
```
[DWH Server] ── WireGuard VPN ── [Private Network] ── MS SQL 2005
```
* VPN must be active before platform startup.

* WireGuard configuration is not part of this repository.

* FDW connects to the internal MS SQL IP address.

🔐 Source Access & Security
[IMPORTANT] The MS SQL source database is accessed using a dedicated read-only user:

User: dwh_extractor
Permissions: READ-ONLY
Purpose: Analytical data extraction via FDW

The user has no write or administrative privileges

It exists exclusively for DWH access

This guarantees zero impact on the OLTP system

🔧 MS SQL Connection Configuration (FDW)
All MS SQL connection parameters are defined in: 
```
sql_scripts/00_platform/fdw_init.sql
```
```SQL
CREATE SERVER minisoft_mssql
FOREIGN DATA WRAPPER tds_fdw
OPTIONS (
  servername '10.0.1.43',
  port '1433',
  database 'minisoft2',
  tds_version '7.4'
);
```
🚀 Execution Flow
First Run (New Server)
```
make build
make bootstrap
```
Result: a fully operational analytical DWH.

Regular Rebuild
```
make rebuild
```
➕ Adding New Source Tables
Update fdw_import.sql.

Run FDW import manually.

Add Bronze / Silver / Gold logic.

[!WARNING] Foreign tables are not imported automatically by design.

<a name="ukrainian-version"></a>

Ukrainian Version
🎯 Мета проєкту
* Відокремити аналітику від OLTP-системи

* Побудувати стабільне DWH на PostgreSQL

* Забезпечити повну відтворюваність на новому сервері

* Використовувати SQL-first підхід без імперативного ETL

🧭 Архітектура
```
MS SQL Server 2005 (MiniSoft, приватна мережа)
        │
        │  tds_fdw (через WireGuard VPN)
        ▼
PostgreSQL 16 (DWH)
│
├── mssql   — foreign tables (контракт джерела)
├── bronze  — сирі дані
├── silver  — підготовлені та очищені дані
└── gold    — аналітична модель
```
🧩 Основні принципи
* FDW замість ETL — пряме читання з MS SQL.

* Шарова архітектура: bronze → silver → gold.

* Ідемпотентність — безпечні повторні запуски.

* Infrastructure as Code — Docker + SQL.

🔐 Доступ до джерела (WireGuard VPN)
[!IMPORTANT] База MS SQL знаходиться у закритій мережі. Доступ можливий лише через WireGuard VPN.
```
[DWH Server] ── WireGuard VPN ── [Приватна мережа] ── MS SQL 2005
```
* VPN має бути активним до запуску платформи.

* WireGuard не входить до цього репозиторію.

* FDW використовує внутрішню IP-адресу MS SQL.
* 🔐 Доступ та безпека
[ВАЖЛИВО]
Для доступу до MS SQL використовується окремий read-only користувач:

Користувач: dwh_extractor
Права: тільки читання
Призначення: аналітичне читання через FDW

Користувач не має прав запису

Використовується виключно для DWH

Гарантує відсутність впливу на OLTP

* 🔧 Налаштування підключення (FDW)
Усі параметри зʼєднання знаходяться у файлі: sql_scripts/00_platform/fdw_init.sql

* 🚀 Порядок запуску
Перший запуск (новий сервер)
```
make build
make bootstrap
```
Повторний перерахунок
```
make rebuild
```
➕ Додавання нових таблиць
Оновити fdw_import.sql.

Запустити імпорт вручну.

Додати Bronze / Silver / Gold логіку.

Artur Hapurkhaiev DWH / Data Platform Engineering
