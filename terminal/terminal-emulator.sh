#!/usr/bin/env bash
# Preferência: WezTerm -> Kitty -> Ghostty
set -u

case "${TERMINAL_EMULATOR:-}" in
  wezterm)  exec wezterm "$@" ;;
  kitty)  exec kitty "$@" ;;
  ghostty)  exec  ghostty "$@" ;;
esac

if command -v wezterm >/dev/null 2>&1 && wezterm --version >/dev/null 2>&1; then
  exec wezterm "$@"
fi

if command -v kitty >/dev/null 2>&1 && kitty --version >/dev/null 2>&1; then
  exec kitty "$@"
fi

if command -v ghostty >/dev/null 2>&1 && ghostty --version >/dev/null 2>&1; then
  exec ghostty "$@"
fi

printf 'Nenhum terminal encontrado: WezTerm, Kitty ou Ghostty\n' >&2

exit 1
