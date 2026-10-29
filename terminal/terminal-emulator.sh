#!/usr/bin/env bash
# Preference: WezTerm -> Kitty -> Ghostty
# Uso: 
#   terminal-emulator.sh [DIRETORIO]
#   terminal-emulator.sh --working-directory DIRETORIO
#   terminal-emulator.sh -e COMAND [ARG...]
#   TERMINAL_EMULATOR=wezterm|kitty|ghostty terminal-emulator.sh
#   TERMINAL_DEBUG=1 terminal-emulator.sh ... (imprime o exec, não abre)
set -u

dir=""
cmd=()
version=0
help=0

# --- interpretação de argumentos comuns entre as DEs ---
i=1
while [ "$i" -le "$#" ]; do
  arg="${!i}"
  case "$arg" in
    --working-directory=*) dir="${arg#*=}" ;;
    --working-directory|-w)
      i=$((i + 1))
      [ "$i" -le "$#" ] || { printf 'Faltou o diretório para %s\n' "$arg" >&2; exit 2; }
      dir="${!i}"
      ;;
    -e|--command)
      i=$((i + 1))
      [ "$i" -le "$#" ] || { printf 'Faltou o comando para %s\n' "$arg" >&2; exit 2; }
      cmd=("${@:i}")
      break
      ;;
    --version|-v) version=1 ;;
    --help|-h) help=1 ;;
    *)
      if [ -z "$dir" ] && [ -d "$arg" ]; then
        dir="$arg"
      else
        cmd=("${@:i}")
        break 
      fi
      ;;
  esac
  i=$((i + 1))
done

# --- escolha do terminal ---
pick() {
  case "${TERMINAL_EMULATOR:-}" in
    wezterm) command -v wezterm >/dev/null 2>&1 && { printf 'wezterm\n'; return 0; } ;;
    kitty) command -v kitty >/dev/null 2>&1 && { printf 'kitty\n'; return 0; } ;;
    ghostty) command -v ghostty >/dev/null 2>&1 && { printf 'ghostty\n'; return 0; } ;;
  esac
  if command -v wezterm >/dev/null 2>&1 && wezterm --version >/dev/null 2>&1; then
    printf 'wezterm\n'
  elif command -v kitty >/dev/null 2>&1 && kitty --version >/dev/null 2>&1; then
    printf 'kitty\n'
  elif command -v ghostty >/dev/null 2>&1 && ghostty --version >/dev/null 2>&1; then
    printf 'ghostty\n'
  else
    return 1
  fi
}

term="$(pick)" || { printf 'Nenhum terminal encontrado: WezTerm, Kitty ou Ghostty\n' >&2; exit 1; }

if [ "$help" -eq 1 ]; then
  sed -n '2,9p' "$0"
  exit  0
fi

# --- montagem dos args por terminal ---
case "$term" in
  wezterm)
    set -- wezterm 
    [ "$version" -eq 1 ] && { exec "$@" --version; }
    set -- "$@" start
    [ -n "$dir" ] && set -- "$@" --cwd "$dir"
    [ "${#cmd[@]}" -gt 0 ] && set -- "$@" -- "${cmd[@]}"
    ;;
  kitty)
    set -- kitty
    [ "$version" -eq 1 ] && { exec "$@" --version; }
    [ -n "$dir" ] && set -- "$@" --directory "$dir"
    [ "${cmd[@]}" -gt 0 ] && set -- "$@" -- "${cmd[@]}"
    ;;
  ghostty)
    set -- ghostty
    [ "$version" -eq 1 ] && { exec "$@" --version; }
    [ -n "$dir" ] && set -- "$@" "+working-directory=$dir"
    [ "${#cmd[@]}" -gt 0 ] && set -- "$@" -e "${cmd[@]}"
    ;;
esac

if [ "${TERMINAL_DEBUG:-0}" = "1" ]; then
  printf 'exec'
  for a in "$@"; do printf ' %q' "$a"; done
  printf '\n'
  exit 0 
fi

exec "$@"
