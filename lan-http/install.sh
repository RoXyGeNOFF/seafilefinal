
#!/bin/bash
set -e

echo "=== Seafile локальная установка ==="

# Проверка Docker
if ! command -v docker &> /dev/null; then
    echo "Устанавливаю Docker..."
    apt-get update && apt-get install -y docker.io
fi

# Проверка Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Устанавливаю Docker Compose..."
    apt-get install -y docker-compose
fi

# Если нет .env, создаём из примера
if [ ! -f .env ]; then
    echo "Файл .env не найден, создаём из .env.example"
    cp .env.example .env
fi

# Загружаем переменные
source .env

# Создание docker-compose.yml
cat > docker-compose.yml <<EOF
version: '3.8'
services:
  db:
    image: mariadb:10.11
    environment:
      - MYSQL_ROOT_PASSWORD=\${DB_ROOT_PASSWD}
    volumes:
      - ./seafile-mysql:/var/lib/mysql
    restart: always

  memcached:
    image: memcached:alpine
    restart: always

  seafile:
    image: seafileltd/seafile-mc:latest # docker.io/seafileltd/seafile:latest  # https://hub.docker.com/r/seafileltd/seafile
    container_name: seafile
    ports:
      - "80:80"
      - "443:443"
    environment:
      - DB_HOST=db
      - DB_ROOT_PASSWD=\${DB_ROOT_PASSWD}
      - SEAFILE_ADMIN_EMAIL=\${SEAFILE_ADMIN_EMAIL}
      - SEAFILE_ADMIN_PASSWORD=\${SEAFILE_ADMIN_PASSWORD}
      - SEAFILE_SERVER_HOSTNAME=\${LOCAL_IP}
    volumes:
      - ./seafile-data:/shared
    depends_on:
      - db
      - memcached
    restart: always
EOF

# Запуск
docker-compose up -d

echo "======================================"
echo "✅ Seafile установлен"
echo "Откройте в браузере: http://$LOCAL_IP"
echo "Email: $SEAFILE_ADMIN_EMAIL"
echo "Пароль: $SEAFILE_ADMIN_PASSWORD"
echo "======================================"
