
# 🚀 Seafile ALL-in-One (Local Network Edition)

Готовый docker-compose для запуска **Seafile Community Edition** в локальной сети.
Готов к автосинхронизации на ноутбуке и телефоне через официальные клиенты Seafile. https://www.seafile.com/en/download/

## 🚀 Быстрый старт

```bash
git clone https://github.com/RoXyGeNOFF/seafilefinal.git
cd seafilefinal
cd lan-http
cp .env.example .env
nano .env   # впишите свои значения (IP, Email, пароли)
chmod +x install.sh
./install.sh
```

После запуска откройте в браузере: `http://<ВАШ_IP>`

## ✨ Стек

- Seafile CE (latest)
- MariaDB
- Memcached
