#!/usr/bin/env bash
# =====================================================
# 🚀 DWH LAYER RUNNER (CLEAN + PRODUCTION)
# =====================================================

set -eE
trap 'on_error $LINENO' ERR

LAYER="$1"   # platform | bronze | silver | gold | all

PG_CONTAINER="dwh-postgres"
PG_DB="dwh"
PG_USER="dwh"

ROOT_DIR="/opt/dwh/sql_scripts"
LOG_DIR="/opt/dwh/logs"

LOG_FILE="${LOG_DIR}/run_${LAYER}.log"

DB_CMD="docker exec -i ${PG_CONTAINER} psql \
  -U ${PG_USER} \
  -d ${PG_DB} \
  -v ON_ERROR_STOP=1 \
  -v client_min_messages=WARNING"

START_TS=$(date +%s)
STEP=1
TOTAL=0
CURRENT_FILE=""

mkdir -p "$LOG_DIR"
: > "$LOG_FILE"

# =========================
# LOGGING
# =========================
log() {
  echo "[`date '+%Y-%m-%d %H:%M:%S'`] $1"
}

# =========================
# ERROR HANDLER
# =========================
on_error() {
  echo
  echo "=============================="
  echo "❌ DWH BUILD FAILED"
  echo "📍 SQL file : ${CURRENT_FILE:-unknown}"
  echo "=============================="
  echo
  echo "🪵 Last 50 log lines:"
  tail -n 50 "$LOG_FILE"
  exit 1
}

# =========================
# PROGRESS BAR
# =========================
progress_bar() {
  local step=$1
  local total=$2
  local label=$3

  local width=30
  local percent=$(( step * 100 / total ))
  (( percent > 100 )) && percent=100

  local filled=$(( percent * width / 100 ))
  local empty=$(( width - filled ))

  printf "\r["
  printf "%0.s█" $(seq 1 $filled)
  printf "%0.s░" $(seq 1 $empty)
  printf "] %3d%% %s" "$percent" "$label"
}

# =========================
# WAIT FOR POSTGRES
# =========================
wait_pg() {
  log "⏳ Waiting for Postgres..."
  until docker exec "$PG_CONTAINER" pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; do
    sleep 2
  done
}

# =========================
# COUNT SQL FILES
# =========================
count_files() {
  TOTAL=0
  for dir in "$@"; do
    if [ -d "$dir" ]; then
      TOTAL=$((TOTAL + $(ls "$dir"/*.sql 2>/dev/null | wc -l)))
    fi
  done
}

# =========================
# RUN SQL FILE
# =========================
run_sql() {
  local file="$1"
  CURRENT_FILE="$file"

  progress_bar "$STEP" "$TOTAL" "$(basename "$file")"
  local t0=$(date +%s)

  $DB_CMD < "$file" >>"$LOG_FILE" 2>&1

  local t1=$(date +%s)
  local dur=$((t1 - t0))

  printf "  ⏱ %ds\n" "$dur"

  STEP=$((STEP + 1))
}

# =========================
# RUN DIRECTORY
# =========================
run_dir() {
  local dir="$1"
  for f in $(ls "$dir"/*.sql 2>/dev/null | sort); do
    run_sql "$f"
  done
}

wait_pg

# =========================
# EXECUTION PLAN
# =========================
case "$LAYER" in
  platform)
    echo "🔌 PLATFORM INIT (FDW / EXTENSIONS)"
    count_files "$ROOT_DIR/00_platform"
    run_dir "$ROOT_DIR/00_platform"
    ;;

  bronze)
    echo "🥉 BRONZE"
    count_files \
      "$ROOT_DIR/00_common" \
      "$ROOT_DIR/10_bronze/01_ddl" \
      "$ROOT_DIR/10_bronze/03_load"

    run_dir "$ROOT_DIR/00_common"
    run_dir "$ROOT_DIR/10_bronze/01_ddl"
    run_dir "$ROOT_DIR/10_bronze/03_load"
    ;;

  silver)
    echo "🥈 SILVER"
    count_files \
      "$ROOT_DIR/20_silver/01_ddl" \
      "$ROOT_DIR/20_silver/03_load"

    run_dir "$ROOT_DIR/20_silver/01_ddl"
    run_dir "$ROOT_DIR/20_silver/03_load"
    ;;

  gold)
    echo "🥇 GOLD"
    count_files \
      "$ROOT_DIR/30_gold/01_ddl" \
      "$ROOT_DIR/30_gold/03_load"

    run_dir "$ROOT_DIR/30_gold/01_ddl"
    run_dir "$ROOT_DIR/30_gold/03_load"
    ;;

  all)
    echo "🔥 FULL DATA REBUILD (NO PLATFORM)"

    $DB_CMD <<'SQL' >>"$LOG_FILE" 2>&1
DROP SCHEMA IF EXISTS gold CASCADE;
DROP SCHEMA IF EXISTS silver CASCADE;
DROP SCHEMA IF EXISTS bronze CASCADE;

CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
SQL

    "$0" bronze
    "$0" silver
    "$0" gold
    exit 0
    ;;

  *)
    echo "Usage: run_layer.sh {platform|bronze|silver|gold|all}"
    exit 1
    ;;
esac

# =========================
# SUMMARY
# =========================
END_TS=$(date +%s)

echo
echo "=============================="
echo "✅ LAYER FINISHED: $LAYER"
echo "⏱ Total time: $((END_TS - START_TS))s"
echo "=============================="
