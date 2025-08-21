#!/usr/bin/env bash
set -euo pipefail

BOLD=$(tput bold || true); GREEN=$(tput setaf 2 || true); RESET=$(tput sgr0 || true)

require() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Требуется $1"; exit 1; }; }
require docker
require openssl

read -rp "IP сервера в LAN: " LOCAL_IP
read -rp "Admin email [admin@${LOCAL_IP}]: " ADMIN_EMAIL; ADMIN_EMAIL=${ADMIN_EMAIL:-admin@${LOCAL_IP}}
read -rp "Admin пароль (пусто = автоген): " ADMIN_PASS; [ -z "$ADMIN_PASS" ] && ADMIN_PASS=$(openssl rand -base64 12) && echo "Сгенерирован пароль: ${ADMIN_PASS}"
read -rp "Каталог данных [/opt/seafile-data]: " DATA_DIR; DATA_DIR=${DATA_DIR:-/opt/seafile-data}

MYSQL_ROOT_PASSWORD=$(openssl rand -base64 18)
SEAFILE_DB_PASSWORD=$(openssl rand -base64 18)
REDIS_PASSWORD=$(openssl rand -base64 18)
JWT_KEY=$(openssl rand -hex 40)

mkdir -p "${DATA_DIR}/seafile" "${DATA_DIR}/mysql"

cat > .env <<EOF
SEAFILE_VOLUME=${DATA_DIR}/seafile
SEAFILE_MYSQL_VOLUME=${DATA_DIR}/mysql

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
SEAFILE_DB_PASSWORD=${SEAFILE_DB_PASSWORD}
REDIS_PASSWORD=${REDIS_PASSWORD}
JWT_PRIVATE_KEY=${JWT_KEY}

LOCAL_IP=${LOCAL_IP}
SEAFILE_SERVER_PROTOCOL=http
TIME_ZONE=UTC
INIT_SEAFILE_ADMIN_EMAIL=${ADMIN_EMAIL}
INIT_SEAFILE_ADMIN_PASSWORD=${ADMIN_PASS}
EOF

docker compose pull
docker compose up -d

echo -e "\n${GREEN}${BOLD}Seafile (LAN HTTP) поднят.${RESET} Откройте: http://${LOCAL_IP}/"
echo "Admin: ${ADMIN_EMAIL}"
echo "Pass:  ${ADMIN_PASS}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"${ROOT_DIR}/scripts/show_image.sh" "${ROOT_DIR}/assets/donate_qr.png" "USDT (TRC20): TDb2rmYkYGoX2o322JmPR12oAUJbkgtaWg"
