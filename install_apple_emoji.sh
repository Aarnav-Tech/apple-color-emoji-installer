#!/usr/bin/env sh

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Privilege check (first thing, before any output) ─────────────────────────
if [ "$(id -u)" -ne 0 ]; then
  printf "${RED}${BOLD}Error:${RESET} This script must be run with sudo or as root.\n"
  printf "Please run: ${BOLD}sudo ./install_apple_emoji.sh${RESET}\n"
  exit 1
fi

# ── Resolve the invoking user (works reliably under sudo) ────────────────────
REAL_USER="${SUDO_USER:-$(logname 2>/dev/null)}"
if [ -z "$REAL_USER" ]; then
  printf "${RED}${BOLD}Error:${RESET} Could not determine the invoking user. Run via sudo.\n"
  exit 1
fi
USER_HOME=$(eval echo "~${REAL_USER}")

# ── ASCII Art header ─────────────────────────────────────────────────────────
cat <<'EOF'


 ________  ________  ________  ___       _______                                                  
|\   __  \|\   __  \|\   __  \|\  \     |\  ___ \                                                 
\ \  \|\  \ \  \|\  \ \  \|\  \ \  \    \ \   __/|                                                
 \ \   __  \ \   ____\ \   ____\ \  \    \ \  \_|/__                                              
  \ \  \ \  \ \  \___|\ \  \___|\ \  \____\ \  \_|\ \                                             
   \ \__\ \__\ \__\    \ \__\    \ \_______\ \_______\                                            
    \|__|\|__|\|__|     \|__|     \|_______|\|_______|                                            
                                                                                                  
 ________  ________  ___       ________  ________                                                 
|\   ____\|\   __  \|\  \     |\   __  \|\   __  \                                                
\ \  \___|\ \  \|\  \ \  \    \ \  \|\  \ \  \|\  \                                               
 \ \  \    \ \  \\\  \ \  \    \ \  \\\  \ \   _  _\                                              
  \ \  \____\ \  \\\  \ \  \____\ \  \\\  \ \  \\  \|                                             
   \ \_______\ \_______\ \_______\ \_______\ \__\\ _\                                             
    \|_______|\|_______|\|_______|\|_______|\|__|\|__|                                            
                                                                                                  
 _______   _____ ______   ________        ___  ___                                                
|\  ___ \ |\   _ \  _   \|\   __  \      |\  \|\  \                                               
\ \   __/|\ \  \\\__\ \  \ \  \|\  \     \ \  \ \  \                                              
 \ \  \_|/_\ \  \\|__| \  \ \  \\\  \  __ \ \  \ \  \                                             
  \ \  \_|\ \ \  \    \ \  \ \  \\\  \|\  \\_\  \ \  \                                            
   \ \_______\ \__\    \ \__\ \_______\ \________\ \__\                                           
    \|_______|\|__|     \|__|\|_______|\|________|\|__|                                           
                                                                                                  
 ___  ________   ________  _________  ________  ___       ___       _______   ________  ___       
|\  \|\   ___  \|\   ____\|\___   ___\\   __  \|\  \     |\  \     |\  ___ \ |\   __  \|\  \      
\ \  \ \  \\ \  \ \  \___|\|___ \  \_\ \  \|\  \ \  \    \ \  \    \ \   __/|\ \  \|\  \ \  \     
 \ \  \ \  \\ \  \ \_____  \   \ \  \ \ \   __  \ \  \    \ \  \    \ \  \_|/_\ \   _  _\ \  \    
  \ \  \ \  \\ \  \|____|\  \   \ \  \ \ \  \ \  \ \  \____\ \  \____\ \  \_|\ \ \  \\  \\ \__\   
   \ \__\ \__\\ \__\____\_\  \   \ \__\ \ \__\ \__\ \_______\ \_______\ \_______\ \__\\ _\\|__|   
    \|__|\|__| \|__|\_________\   \|__|  \|__|\|__|\|_______|\|_______|\|_______|\|__|\|__|   ___ 
                   \|_________|                                                              |\__\
                                                                                             \|__|


EOF

printf "${BOLD}Installing Apple Color Emoji for Linux...${RESET}\n\n"
sleep 2

# ── Dependency check ─────────────────────────────────────────────────────────
if ! command -v wget > /dev/null 2>&1; then
  printf "${RED}${BOLD}Error:${RESET} wget is not installed. Please install it and retry.\n"
  printf "  On Arch/EndeavourOS: ${BOLD}sudo pacman -S wget${RESET}\n"
  printf "  On Debian/Ubuntu:    ${BOLD}sudo apt install wget${RESET}\n"
  exit 1
fi

# ── Font directory ───────────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[1/6] Creating font directory for ${REAL_USER}...${RESET}\n"
FONT_DIR="${USER_HOME}/.local/share/fonts"
mkdir -p "${FONT_DIR}"

# ── Download font ────────────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[2/6] Downloading Apple Color Emoji font...${RESET}\n"
FONT_URL="https://github.com/samuelngs/apple-emoji-ttf/releases/download/macos-26-20260219-2aa12422/AppleColorEmoji-Linux.ttf"
FONT_DEST="${FONT_DIR}/AppleColorEmoji-Linux.ttf"

  wget --show-progress -q "$FONT_URL" -O "$FONT_DEST"

if [ ! -f "$FONT_DEST" ] || [ ! -s "$FONT_DEST" ]; then
  printf "${RED}${BOLD}Error:${RESET} Font download failed. Please check your internet connection.\n"
  rm -f "$FONT_DEST"
  exit 1
fi

# ── System-wide fontconfig ───────────────────────────────────────────────────
printf "${BOLD}${GREEN}[3/6] Updating system fontconfig emoji priority...${RESET}\n"
SYSTEM_CONF="/etc/fonts/conf.d/60-generic.conf"
if [ -f "$SYSTEM_CONF" ]; then
  cp "$SYSTEM_CONF" "${SYSTEM_CONF}.bak"
  printf "      Backed up existing config to ${SYSTEM_CONF}.bak\n"
fi

tee "$SYSTEM_CONF" > /dev/null <<EOL
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias binding="same">
    <family>emoji</family>
    <prefer>
      <family>Apple Color Emoji</family>
      <family>Noto Color Emoji</family>
      <family>Segoe UI Emoji</family>
      <family>Twitter Color Emoji</family>
      <family>EmojiOne Mozilla</family>
      <family>Emoji Two</family>
      <family>Emoji One</family>
      <family>Noto Emoji</family>
      <family>Android Emoji</family>
    </prefer>
  </alias>
</fontconfig>
EOL

# ── Per-user fontconfig override ─────────────────────────────────────────────
printf "${BOLD}${GREEN}[4/6] Writing per-user fontconfig override...${RESET}\n"
USER_CONFIG_DIR="${USER_HOME}/.config/fontconfig"
mkdir -p "${USER_CONFIG_DIR}"

tee "${USER_CONFIG_DIR}/fonts.conf" > /dev/null <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Apple Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Apple Color Emoji</family>
    </prefer>
  </alias>
  <alias>
    <family>monospace</family>
    <prefer>
      <family>Apple Color Emoji</family>
    </prefer>
  </alias>
  <match target="pattern">
    <test qual="any" name="family"><string>Noto Color Emoji</string></test>
    <edit name="family" mode="assign" binding="same"><string>Apple Color Emoji</string></edit>
  </match>
</fontconfig>
EOL

# ── Fix ownership ────────────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[5/6] Fixing file ownership for ${REAL_USER}...${RESET}\n"
chown -R "${REAL_USER}:${REAL_USER}" "${FONT_DIR}"
chown -R "${REAL_USER}:${REAL_USER}" "${USER_CONFIG_DIR}"

# ── Rebuild font cache ───────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[6/6] Rebuilding font cache...${RESET}\n"
fc-cache -f -v

# ── Done ─────────────────────────────────────────────────────────────────────
printf "\n${BOLD}${GREEN}Installation complete!${RESET}\n"
printf "${BOLD}Please restart your applications or log out and back in to apply changes.${RESET}\n\n"

# ── Reboot prompt ────────────────────────────────────────────────────────────
printf "${BOLD}Would you like to restart your computer now? (y/n): ${RESET}"
read -r answer

case "$answer" in
  [Yy]*)
    printf "${BOLD}${GREEN}Restarting now...${RESET}\n"
    systemctl reboot
    ;;
  [Nn]*)
    printf "${BOLD}${GREEN}Restart skipped. Remember to reboot later to apply all changes.${RESET}\n"
    ;;
  *)
    printf "${RED}Unrecognised input. Please reboot manually for changes to take full effect.${RESET}\n"
    ;;
esac
