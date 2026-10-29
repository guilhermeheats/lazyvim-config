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
#   5) Nerd Fonts e Fontes Fallbacks
#   6) Config em ~/.config/lazyvim/ (clone ou pull)
#   7) Terminais (WezTerm, Kitty, Ghostty) com fallback
#   8) Configs dos terminais + registro do terminal padrão por DE
#   9) Concluído
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
  texlive-fonts-recommended texlive-lang-portuguese texlive-pictures \
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
info "Instalando fontes (JetBrainsMono NF, MesloLGS NF, OpenDyslexic NF, OpenDyslexic) ..."

# 5a) JetBrainsMono Nerd Font (terminais - ícones)
fontdir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
mkdir -p "$fontdir"
tmp="$(mktemp -d)"
if curl -fL --progress-bar \
  "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
  -o "$tmp/font.zip"; then
  unzip -oq "$tmp/font.zip" -d "$fontdir"
else
  warn \
  "Não foi possível baixar JetBrainsMono.zip - Baixe manualmente em https://github.com/ryanoasis/nerd-fonts/releases/latest"
fi
rm -rf "$tmp"

# 5b) JetBrainsMono (simples - system)
if ! sudo apt-get install -y fonts-jetbrains-mono; then
  warn "fonts-jetbrains-mono indisponível - Baixe manualmente em https://www.jetbrains.com/lp/mono (ou instale o .ttf daqui)"
fi

# 5c) MesloLGS NF (Fonte principal)
fontdir="$HOME/.local/share/fonts/MesloLGS"
mkdir -p "$fontdir"
base="https://github.com/romkatv/powerlevel10k-media/raw/master"
for f in "MesloLGS%20NF%20Regular.ttf" "MesloLGS%20NF%20Bold.ttf" \
         "MesloLGS%20NF%20Italic.ttf" "MesloLGS%20NF%20Bold%20Italic.ttf"; do
    curl -fL --progress-bar "$base/$f" -o "$fontdir/${f//%20/ }" ||
      warn "Falha ao baixar $f - Baixe manualmente em https://github.com/romkatv/powerlevel10k-media"
done

# 5d) OpenDyslexic Nerd Font
fontdir="$HOME/.local/share/fonts/OpenDyslexicNerdFont"
mkdir -p "$fontdir"
tmp="$(mktemp -d)"
if curl -fL --progress-bar \
   "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/OpenDyslexic.zip" \
   -o "$tmp/font.zip"; then
   unzip -oq "$tmp/font.zip" -d "$fontdir"
else
  warn "Não foi possível baixar OpenDyslexic.zip - Baixe manualmente em https://github.com/ryanoasis/nerd-fonts/releases/latest"
fi
rm -rf "$tmp"

# 5e) OpenDyslexic (simples - system)
if ! sudo apt-get install -y fonts-opendyslexic; then
  warn "fonts-opendyslexic indisponível - Baixe manualmente em https://opendyslexic.org/"
fi

fc-cache -f >/dev/null

# --------------------------------------------------------------- 6) config ------------
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

# --------------------------------------------------------------- 7) terminais ----------
info "instalando terminais (WezTerm, Kitty, Ghostty) ..."

have_term() { command -v "$1" >/dev/null 2>&1; }

# --- Kitty: apt (trixie) -> GitHub (txz portátil) ---
if have_term kitty; then
  info "kitty já instalado: $(kitty --version | head -n1)"
elif sudo apt-get install -y kitty >/dev/null; then
  info "kitty instalado via apt."
else 
  warn "Kitty via apt falhou - Baixando do GitHub ..."
  ver=$(curl -fsSL https://api.github.com/repos/kovidgoyal/kitty/releases/latest \
    | grep -oE '"tag_name": "v[^"]+"' | head -1 | cut -d'"' -f4)
  ver="${ver#v}"
  url="https://github.com/kovidgoyal/kitty/releases/download/v${ver}/kitty-${ver}-x86_64.txz"
  tmp="$(mktemp -d)"
  if curl -fL --progress-bar "$url" -o "$tmp/kitty.txz" && tar -xf "$tmp/kitty.txz" -C "$tmp"; then
    mkdir -p "$HOME/.local/opt"
    rm -rf "$HOME/.local/"
    mv "$tmp/kitty-${ver}-x86_64" "$HOME/.local/opt/kitty"
    ln -sf "$HOME/.local/opt/kitty/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sf "$HOME/.local/opt/kitty/bin/kitten" "$HOME/.local/bin/kitten"
    warn "kitty portátil instalado em ~/.local/opt/kitty (atualizações manuais)."
  else
    warn "Falha no Download do Kitty - Instale manualmente: https://github.com/kovidgoyal/kitty/releases"
  fi
  rm -rf "$tmp"
fi

# --- WezTerm: apt (futuro) -> GitHub (.deb Debian12) ---
if have_term wezterm; then
  info "WezTerm já instalado: $(wezterm --version | head -n1)"
elif sudo apt-get install -y wezterm >/dev/null 2>&1; then
  info "WezTerm instalado via apt."
else
  warn "WezTerm via apt falhou - Baixando o .deb do GitHub ..."
  ver="20240203-110809-5046fc22"
  url="https://github.com/wezterm/wezterm/releases/download/${ver}/wezterm-${ver}.Debian12.deb"
  tmp="$(mktemp -d)"
  if curl -fL --progress-bar "$url" -o "$tmp/wezterm.deb"; then
    sudo apt-get install -y "$tmp/wezterm.deb" ||
      warn "Não foi possível instalar o .deb - Tente manualmente: $url"
  else
    warn "Falha no download do WezTerm - Instale manualmente: https://github.com/wezterm/wezterm/releases"
  fi
  rm -rf "$tmp"
fi

# --- Ghostty: apt (futuro) -> GitHub (mkasberg, .deb trixie) ---
if have_term ghostty ;then
  info "Ghostty já instalado: $(ghostty --version | head -n1)"
elif sudo apt-get install -y ghostty >/dev/null 2>&1; then
  info "Ghostty instalado via apt."
else 
  warn "Ghostty via apt falhou - Baixando o .deb do GitHub (mkasberg/ghostty-ubuntu) ..."
  url=$(curl -fsSL https://api.github.com/repos/mkasberg/ghostty-ubuntu/releases/latest \
    | grep -oE '"browser_download_url": "[^"]*_amd64_trixie\.deb"' | head -1 | cut -d'"' -f4)
  tmp="$(mktemp -d)"
  if [ -n "$url" ] && curl -fL --progress-bar "$url" -o "$tmp/ghostty.deb"; then
    sudo apt-get install -y "$tmp/ghostty.deb" || 
      warn "Não foi possível instalar o .deb - Tente manualmente: $url"
  else
    warn "Falha no Download do Ghostty - Instale manualmente: httsp://github.com/mkasberg/ghostty-ubuntu/releases"
  fi
  rm -rf "$tmp"
fi

# -------------------------------------------------------- 8) configs + registro DE -----
info "Copiando configs dos terminais ..."
mkdir -p "$HOME/.config/wezterm" "$HOME/.config/kitty" "$HOME/.config/ghostty"
cp "$CONFIG_DIR/terminal/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
cp "$CONFIG_DIR/terminal/kitty.conf" "$HOME/.config/kitty/kitty.conf"
cp "$CONFIG_DIR/terminal/ghostty.conf" "$HOME/.config/ghostty/config"

info "Instalando wrapper e .desktop ..."
install -m 755 "$CONFIG_DIR/terminal/terminal-emulator.sh" "$HOME/.local/bin/terminal-emulator.sh"
mkdir -p "$HOME/.local/share/applications"
sed "s|/home/guilherme-heats|$HOME|g" \
  "$CONFIG_DIR/terminal/terminal-emulator.desktop" \
  > "$HOME/.local/share/applications/terminal-emulator.desktop"
chmod 644 "$HOME/.local/share/applications/terminal-emulator.desktop"

mkdir -p "$HOME/.local/share/xfce4/helpers"
sed "s|/home/guilherme-heats/|$HOME|g" \
  "$CONFIG_DIR/terminal/custom-TerminalEmulator.desktop" \
  > "$HOME/.local/share/xfce4/helpers/custom-TerminalEmulator.desktop"
chmod 644 "$HOME/.local/share/xfce4/helpers/custom-TerminalEmulator.desktop"

# --- spec XDG (xdg-terminal-exec) - Universal ---
printf 'terminal-emulator.desktop\n' > "$HOME/.config/xdg-terminals.list"

# --- Fallback universal do Deian ---
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator \
  "$HOME/.local/bin/terminal-emulator.sh" 60 || 
  warn "Não foi possível registrar x-terminal-emulator."

# --- Registro do terminal padrão por DE ---
desktop_lc="$(printf '%s' "${XDG_CURRENT_DESKTOP:-}" | tr 'A-Z' 'a-z')"
case "$desktop_lc" in
  *xfce*)
    rc="$HOME/.config/xfce4/help.rc"
    mkdir -p "$(dirname "$rc")"
    touch "$rc"
    if grep -q '^TerminalEmulator=' "$rc";then
      sed -i 's|^TerminalEmulator=.*|TerminalEmulator=custom-TerminalEmulator|' "$rc"
    else 
      printf 'TerminalEmulator=custom-TerminalEmulator\n' >> "$rc"
    fi
    ;;
  *gnome*|*unity*|*budgie*)
    gsettings set org.gnome.desktop.default-applications.terminal exec "$HOME/.local/bin/terminal-emulator.sh" \
      || warn "gsettings falhou."
    gsettings set org.gnome.desktop.default-applications.terminal exec-arg '' \
      || warn "gsettings falhou."
    ;;
  *cinnamon*)
    gsettings set org.cinnamon.desktop.default-applications.terminal exec "$HOME/.local/bin/terminal-emulator.sh" \
      || warn "gsettings falhou."
    gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '' \
      || warn "gsettings falhou."
    ;;
  *mate*)
    gsettings set org.mate.applications-terminal exec "$HOME/.local/bin/terminal-emulator.sh" \
      || warn "gsettings falhou."
    gsettings set org.mate.applications-terminal exec-arg '' \
      || warn "gsettings falhou."
    ;;
  *lxqt*)
    for f in "$HOME/.config/lxqt-qtxdg.conf" "$HOME/.config/lxqt/qtxdg.conf"; do
      mkdir -p "$(dirname "$f")"
      touch "$f"
      if grep -q '^TerminalEmulator=' "$f"; then
        sed -i 's|^TerminalEmulator=.*|TerminalEmulator=terminal-emulator.desktop|' "$f"
      else 
        printf '[General]\nTerminalEmulator=terminal-emulator.desktop\n' >> "$f"
      fi
    done
    ;;
  *kde*)
    kc=""
    for c in kwriteconfig6 kwriteconfig5; do
      command -v "$c" >/dev/null 2>&1 && { kc="$c"; break; }
    done 
    if [ -n "$kc" ]; then
      "$kc" --file kdeglobals --group General --key TerminalApplication terminal-emulator.desktop
      "$kc" --file kdeglobals --group General --key TerminalService terminal-emulator.desktop
    else
      kf="$HOME/.config/kdeglobals"
      mkdir -p "$(dirname "$kf")"
      touch "$kf"
      grep -q '^TerminalApplication=' "$kf" || printf '[General]\nTerminalApplication=terminal-emulator.desktop\n' >> "$kf"
      grep -q '^TerminalService=' "$kf" || printf 'TerminalService=terminal-emulator.desktop\n' >> "$kf"
    fi  
    ;;
  *)
    warn "DE '${XDG_CURRENT_DESKTOP:-}' não reconhecida - Registrado só .desktop + xdg-terminals.list + x-terminal-emulator."
    ;;
esac

# --------------------------------------------------------------- 9) concluído ----------
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
