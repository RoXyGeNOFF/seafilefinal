# Seafile ALL‑in‑ONE (production + LAN)

Три готовых варианта запуска Seafile CE 12 в Docker:

- `production/` — публичный сервер c **Let's Encrypt (HTTPS)**
- `lan-ssl/` — локальная сеть c **self‑signed SSL**
- `lan-http/` — локальная сеть **HTTP Only**

## Быстрый старт
```bash
git clone https://github.com/RoXyGeNOFF/seafilefinal.git
cd seafilefinal
```

Перейдите в нужную папку и выполните:
```bash
chmod +x install.sh
./install.sh
```
# Elasticsearch надо доработать образ ибо стоит на амазоне и раскоментить в компосе. пока готовый конфиг тока лан-хпп
