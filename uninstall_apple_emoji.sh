#!/usr/bin/env sh

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Privilege check ───────────────────────────────────────────────────────────
if [ "$(id -u)" -ne 0 ]; then
  printf "${RED}${BOLD}Error:${RESET} This script must be run with sudo or as root.\n"
  printf "Please run: ${BOLD}sudo ./uninstall_apple_emoji.sh${RESET}\n"
  exit 1
fi

# ── Resolve the invoking user ─────────────────────────────────────────────────
REAL_USER="${SUDO_USER:-$(logname 2>/dev/null)}"
if [ -z "$REAL_USER" ]; then
  printf "${RED}${BOLD}Error:${RESET} Could not determine the invoking user. Run via sudo.\n"
  exit 1
fi
USER_HOME=$(eval echo "~${REAL_USER}")

# ── ASCII Art header ──────────────────────────────────────────────────────────
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
                                                                                                  
 ___  ___  ________   ___  ________   ________  _________  ________  ___       ___                
|\  \|\  \|\   ___  \|\  \|\   ___  \|\   ____\|\___   ___\\   __  \|\  \     |\  \               
\ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \ \  \___|\|___ \  \_\ \  \|\  \ \  \    \ \  \              
 \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \ \_____  \   \ \  \ \ \   __  \ \  \    \ \  \             
  \ \  \ \  \ \  \\ \  \ \  \ \  \\ \  \|____|\  \   \ \  \ \ \  \ \  \ \  \____\ \  \____        
   \ \__\ \__\ \__\\ \__\ \__\ \__\\ \__\____\_\  \   \ \__\ \ \__\ \__\ \_______\ \_______\      
    \|__|\|__|\|__| \|__|\|__|\|__| \|__|\_________\   \|__|  \|__|\|__|\|_______|\|_______|      
                                         \|_________|                                              


EOF

printf "${BOLD}Uninstalling Apple Color Emoji from Linux...${RESET}\n\n"
sleep 2

# ── Confirm before proceeding ─────────────────────────────────────────────────
printf "${YELLOW}${BOLD}Warning:${RESET} This will remove the Apple Color Emoji font and revert fontconfig changes.\n"
printf "${BOLD}Are you sure you want to continue? (y/n): ${RESET}"
read -r confirm

case "$confirm" in
  [Yy]*) ;;
  *)
    printf "${BOLD}Uninstall cancelled.${RESET}\n"
    exit 0
    ;;
esac

printf "\n"

# ── Remove font file ──────────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[1/4] Removing Apple Color Emoji font...${RESET}\n"
FONT_FILE="${USER_HOME}/.local/share/fonts/AppleColorEmoji-Linux.ttf"
if [ -f "$FONT_FILE" ]; then
  rm -f "$FONT_FILE"
  printf "      Removed: ${FONT_FILE}\n"
else
  printf "      ${YELLOW}Font file not found, skipping.${RESET}\n"
fi

# ── Restore or remove system fontconfig ──────────────────────────────────────
printf "${BOLD}${GREEN}[2/4] Restoring system fontconfig...${RESET}\n"
SYSTEM_CONF="/etc/fonts/conf.d/60-generic.conf"
SYSTEM_CONF_BAK="${SYSTEM_CONF}.bak"

if [ -f "$SYSTEM_CONF_BAK" ]; then
  mv "$SYSTEM_CONF_BAK" "$SYSTEM_CONF"
  printf "      Restored backup: ${SYSTEM_CONF}\n"
elif [ -f "$SYSTEM_CONF" ]; then
  rm -f "$SYSTEM_CONF"
  printf "      No backup found. Removed: ${SYSTEM_CONF}\n"
else
  printf "      ${YELLOW}System fontconfig not found, skipping.${RESET}\n"
fi

# ── Remove per-user fontconfig override ──────────────────────────────────────
printf "${BOLD}${GREEN}[3/4] Removing per-user fontconfig override...${RESET}\n"
USER_FONTS_CONF="${USER_HOME}/.config/fontconfig/fonts.conf"
if [ -f "$USER_FONTS_CONF" ]; then
  rm -f "$USER_FONTS_CONF"
  printf "      Removed: ${USER_FONTS_CONF}\n"
  # Remove the directory only if now empty
  rmdir --ignore-fail-on-non-empty "${USER_HOME}/.config/fontconfig" 2>/dev/null || true
else
  printf "      ${YELLOW}User fontconfig not found, skipping.${RESET}\n"
fi

# ── Rebuild font cache ────────────────────────────────────────────────────────
printf "${BOLD}${GREEN}[4/4] Rebuilding font cache...${RESET}\n"
fc-cache -f -v

# ── Done ──────────────────────────────────────────────────────────────────────
printf "\n${BOLD}${GREEN}Uninstall complete!${RESET}\n"
printf "${BOLD}Your system will revert to its previous emoji font after a restart.${RESET}\n\n"

# ── Reboot prompt ─────────────────────────────────────────────────────────────
printf "${BOLD}Would you like to restart your computer now? (y/n): ${RESET}"
read -r answer

case "$answer" in
  [Yy]*)
    printf "${BOLD}${GREEN}Restarting now...${RESET}\n"
    systemctl reboot
    ;;
  [Nn]*)
    printf "${BOLD}${GREEN}Restart skipped. Remember to reboot later to fully apply changes.${RESET}\n"
    ;;
  *)
    printf "${RED}Unrecognised input. Please reboot manually for changes to take full effect.${RESET}\n"
    ;;
esac
