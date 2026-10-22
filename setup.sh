#!/usr/bin/env bash
# ===============================================================================
# setup.sh - Recria este ambiente do zero num PC Novo (Debian-base x86_64)
#
# Uso:
#   bash setup.sh
# ou, se o repo ainda não estiver clonado:
#   REPO_URL=git@github.com:guilhermeheats/lazyvim-config.git bash setup.sh
#
# Passos:
#   1) pacotes do sistema (LaTeX, zathura, ferramentas, Java)
#   2) pylatexenc via pipx (fórmulas no .md)
#   3) Neovim v0.12.6 em ~/.local/opt/nvim-lazy
#   4) Lançador ~/.local/bin/lazyvim
#   5) fonte JetBrainsMono Nerd Font
#   6) Config em ~/.config/lazyvim/ (clone ou pull)
# ===============================================================================
set -euo pipefail

REPO_URL="git@github.com:guilhermeheats/lazyvim-config.git"
NVIM_VERSION="v0.12.6"
NVIM_DIR="$HOME/.local/opt/nvim-lazy"
CONFIG_DIR="$HOME/.config/lazyvim"
LAUNCHER="$HOME/.local/bin/lazyvim"

info() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mAVISO: %s\033[0m\n' "$*"; }
die() {
  printf '\033[1;31mERRO: %s\033[0m\n' "$*" >&2
  exit 1
}

# --------------------------------------------------------------- sanity ---------
[ "$(uname -s)" = "Linux" ] || die "este script é para Linux"
[ "$(uname -m)" = "x86_64" ] || die "este script preparado para x86_64"
[ "$(id -u)" -ne 0 ] || die "não rodar como root - pedirá 'sudo' quando for preciso"
command -v apt-get >/dev/null || die "o gerenciador de pacotes precisa ser apt-get"
command -v sudo >/dev/null || die "'sudo' não encontrado no sistema"

# --------------------------------------------------------------- 1) packages ----
info "Instalando pacotes do sistema - Irá pedir a senha para o 'sudo'..."
sudo apt-get update
sudo apt-get install -y \
  git ripgrep fd-find lazygit build-essential unzip curl wget \
  nodejs npm python3 pipx fontconfig default-jdk-headless \
  texlive-latex-base texlive-latex-recommended texlive-latex-extra \
  texlive-latex-recommended texlive-lang-portuguese texlive-pictures \
  latexmk zathura zathura-pdf-poppler

# no Debian o bin do fd chama-se 'fdfind'; Neovim espera 'fd'
mkdir -p "$HOME/.local/bin"
command -v fd >/dev/null 2>&1 || ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

# --------------------------------------------------------------- 2) pylatexenc ----
info "Instalando pylatexenc (latex2text) via pipx..."
pipx install pylatexenc || pipx upgrade pylatexenc ||
  warn "Não foi possível instalar o pylatexenc - Rodar 'pipx install pylatexenc' manualmente."

# --------------------------------------------------------------- 3) neovim --------
if [ -x "$NVIM_DIR/bin/nvim" ]; then
  info "Neovim já existe em $NVIM_DIR - Pulando o Download..."
else
  info "Baixando Neovim $NVIM_VERSION ..."
  mkdir -p "$HOME/.local/opt"
  tmp="$(mktemp -d)"
  curl -fL --progress-bar \
    "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.tar.gz" \
    -o "$tmp/nvim.tar.gz"
  tar -xzf "$tmp/nvim.tar.gz" -C "$tmp"
  src="$(find "$tmp" -maxdepth 1 -type d -name 'nvim-linux*' | head -n1)"
  [ -n "$src" ] || die "Layout inesperado no tarball do Neovim."
  rm -rf "$NVIM_DIR"
  mv "$src" "$NVIM_DIR"
  rm -rf "$tmp"
  info "Neovim instalado: $("$NVIM_DIR/bin/nvim" --version | head -n1)"
fi

# --------------------------------------------------------------- 4) launcher ------
info "Criando launcher $LAUNCHER ..."
cat >"$LAUNCHER" <<'LAUNCHER_EOF'
#!/usr/bin/env bash
export NVIM_APPNAME=lazyvim
exec "$HOME/.local/opt/nvim-lazy/bin/nvim" "$@"
LAUNCHER_EOF
chmod +x "$LAUNCHER"

case ":$PATH:" in
*":$HOME/.local/bin:"*) : ;;
*)
  warn "~/.local/bin não está no 'PATH' desta sessão."
  warn 'Adicione no ~/.zshrc ou ~/.bashrc : export PATH="$HOME/.local/bin/:$PATH"'
  ;;
esac

# --------------------------------------------------------------- 5) font -----------
info "Instalando JetBrainsMono Nerd Font ..."
fontdir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
mkdir -p "$fontdir"
tmp="$(mktemp -d)"
if curl -fL --progress-bar \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
  -o "$tmp/font.zip"; then
  unzip -oq "$tmp/font.zip" -d "$fontdir"
  fc-cache -f "$fontdir" >/dev/null
  info "Fonte instalada em $fontdir"
else
  warn "Não foi possível realizar o download da fonte - Instale manualmente."
fi
rm -rf "$tmp"

# --------------------------------------------------------------- 6) config ----------
if [ -d "$CONFIG_DIR/.git" ]; then
  info "Config já existe em $CONFIG_DIR - Atualizando com o 'git pull' ..."
  git -C "$CONFIG_DIR" pull --ff-only || warn "'git pull' falhou - Atualize manualmente."
elif [ -n "$REPO_URL" ]; then
  info "Clonando $REPO_URL -> $CONFIG_DIR ..."
  mkdir -p "$(dirname "$CONFIG_DIR")"
  git clone "$REPO_URL" "$CONFIG_DIR"
else
  warn "Config não encontrada em $CONFIG_DIR e REPO_URL não foi definido."
  warn "Rode de novo assim: REPO_URL=git@github.com:guilhermeheats/lazyvim-config.git bash setup.sh"
  warn "Ou clone manualmente: git clone git@github.com:guilhermeheats/lazyvim-config.git ~/.config/lazyvim"
fi

# --------------------------------------------------------------- 7) concluído ----------
info "Concluído!"
cat <<'FIM'

Próximos passos:
  1. Rode: lazyvim
    (Na primeira vez, o lazy.nvim se instala e baixa todos os plugins do 
lazy-lock.json - Necessita de internet).
  2. Abra arquivos dos tipos que você usa (.tex, .py, .md ...) para o Mason 
instalar os servidores (texlab, pyright, marksman ...) e o Treesitter 
compilar os parsers.
  3. Confira: :Lazy   |   :Mason   |   :checkhealth

Backup de dados (não é config - restauração à parte): 
  - Notas:   ~/.vault
  - Obsidian: https://github.com/obsidianmd/obsidian-releases/releases/download/v1.14.4/Obsidian-1.14.4.AppImage
FIM
