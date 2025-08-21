# Seafile ALL‑in‑ONE (production + LAN)

Три готовых варианта запуска Seafile CE 12 в Docker:

- `production/` — публичный сервер c **Let's Encrypt (HTTPS)**
- `lan-ssl/` — локальная сеть c **self‑signed SSL**
- `lan-http/` — локальная сеть **HTTP Only**

## Быстрый старт
Перейдите в нужную папку и выполните:
```bash
chmod +x install.sh
./install.sh
```
После успешной установки скрипт покажет QR‑код (USDT TRC20) **картинкой** прямо в терминале (если терминал поддерживает графику). В противном случае — выведет путь к файлу `assets/donate_qr.png`.

## Требования
- Docker Engine + Docker Compose plugin
- OpenSSL (для генерации ключей/сертификатов в LAN SSL)
- Для отрисовки QR‑кода картинкой терминал должен поддерживать Kitty/iterm2/chafa/viu (необязательно).
