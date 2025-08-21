#!/usr/bin/env bash
# scripts/show_image.sh - try to render an image in terminal. Fallback to text.
set -euo pipefail

IMG="${1:-}"
DONATE_TEXT="${2:-}"

if [ -z "${IMG}" ] || [ ! -f "${IMG}" ]; then
  echo "Image not found: ${IMG}"; exit 0
fi

# 1) Kitty (icat)
if command -v kitty >/dev/null 2>&1; then
  if kitty +kitten icat --silent --transfer-mode=stream --stdin-no-echo "${IMG}" >/dev/null 2>&1; then
    echo ""
    [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
    exit 0
  fi
fi

# 2) iTerm2 imgcat
if command -v imgcat >/dev/null 2>&1; then
  imgcat "${IMG}" || true
  [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
  exit 0
fi

# 3) wezterm (it supports iTerm or can show via wezterm imgcat if installed)
if command -v wezterm >/dev/null 2>&1 && command -v imgcat >/dev/null 2>&1; then
  imgcat "${IMG}" || true
  [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
  exit 0
fi

# 4) chafa
if command -v chafa >/dev/null 2>&1; then
  if chafa -f sixel -s 60x20 "${IMG}" 2>/dev/null; then
    [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
    exit 0
  else
    chafa -c full -s 60x20 "${IMG}" || true
    [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
    exit 0
  fi
fi

# 5) viu
if command -v viu >/dev/null 2>&1; then
  viu -w 50 -h 25 "${IMG}" || true
  [ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
  exit 0
fi

echo "⚠️  Не удалось отрисовать картинку в текущем терминале."
[ -n "${DONATE_TEXT}" ] && echo "${DONATE_TEXT}"
echo "Откройте файл вручную: ${IMG}"
exit 0
