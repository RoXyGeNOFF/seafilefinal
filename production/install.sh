#!/usr/bin/env bash
set -euo pipefail

BOLD=$(tput bold || true); GREEN=$(tput setaf 2 || true); YELLOW=$(tput setaf 3 || true); RESET=$(tput sgr0 || true)

require() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Требуется $1"; exit 1; }; }
require docker
require openssl

read -rp "Домен (например, seafile.example.com): " DOMAIN
read -rp "Email для Let's Encrypt: " EMAIL
read -rp "Admin email [admin@${DOMAIN}]: " ADMIN_EMAIL; ADMIN_EMAIL=${ADMIN_EMAIL:-admin@${DOMAIN}}
read -rp "Admin пароль (пусто = автоген): " ADMIN_PASS; [ -z "$ADMIN_PASS" ] && ADMIN_PASS=$(openssl rand -base64 12) && echo "Сгенерирован пароль: ${ADMIN_PASS}"
read -rp "HTTP порт [80]: " HTTP_PORT; HTTP_PORT=${HTTP_PORT:-80}
read -rp "HTTPS порт [443]: " HTTPS_PORT; HTTPS_PORT=${HTTPS_PORT:-443}
read -rp "Каталог данных [/opt/seafile-data]: " DATA_DIR; DATA_DIR=${DATA_DIR:-/opt/seafile-data}

MYSQL_ROOT_PASSWORD=$(openssl rand -base64 18)
SEAFILE_DB_PASSWORD=$(openssl rand -base64 18)
REDIS_PASSWORD=$(openssl rand -base64 18)
JWT_KEY=$(openssl rand -hex 40)

mkdir -p "${DATA_DIR}/seafile" "${DATA_DIR}/mysql" "./certbot/conf" "./certbot/www"

cat > .env <<EOF
SEAFILE_VOLUME=${DATA_DIR}/seafile
SEAFILE_MYSQL_VOLUME=${DATA_DIR}/mysql

MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
SEAFILE_DB_PASSWORD=${SEAFILE_DB_PASSWORD}
REDIS_PASSWORD=${REDIS_PASSWORD}
JWT_PRIVATE_KEY=${JWT_KEY}

SEAFILE_SERVER_HOSTNAME=${DOMAIN}
SEAFILE_SERVER_PROTOCOL=https
TIME_ZONE=UTC
INIT_SEAFILE_ADMIN_EMAIL=${ADMIN_EMAIL}
INIT_SEAFILE_ADMIN_PASSWORD=${ADMIN_PASS}

HTTP_PORT=${HTTP_PORT}
HTTPS_PORT=${HTTPS_PORT}
LETSENCRYPT_EMAIL=${EMAIL}
EOF

# попытка выпустить стартовый сертификат (webroot)
docker run --rm -v "$(pwd)/certbot/conf:/etc/letsencrypt" -v "$(pwd)/certbot/www:/var/www/certbot" certbot/certbot certonly \
  --webroot -w /var/www/certbot -d "${DOMAIN}" --email "${EMAIL}" --agree-tos --no-eff-email || true

docker compose pull
docker compose up -d

echo -e "\n${GREEN}${BOLD}Seafile (production) поднят.${RESET} Откройте: https://${DOMAIN}/"
echo "Admin: ${ADMIN_EMAIL}"
echo "Pass:  ${ADMIN_PASS}"

# Показать QR картинкой
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
"${ROOT_DIR}/scripts/show_image.sh" "${ROOT_DIR}/assets/donate_qr.png" "USDT (TRC20): TDb2rmYkYGoX2o322JmPR12oAUJbkgtaWg"
