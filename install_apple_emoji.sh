#!/usr/bin/env sh

# Print ASCII Art header
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

printf "${BOLD}Loading.....\n"

sleep 5

# Color codes for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

# Check if running as root or with sudo
if [ "$(id -u)" -ne 0 ]; then
  printf "${RED}${BOLD}Error:${RESET} This script must be run with sudo or as root.\n"
  printf "Please run: ${BOLD}sudo ./install_apple_emoji.sh${RESET}\n"
  exit 1
fi

printf "${BOLD}${GREEN}Creating font directory for user...${RESET}\n"
# Directory for the invoking user's fonts, not root's home
USER_HOME=$(eval echo "~$(logname)")
mkdir -p "${USER_HOME}/.local/share/fonts/"

printf "${BOLD}${GREEN}Downloading Apple Color Emoji font...${RESET}\n"
wget https://github.com/samuelngs/apple-emoji-linux/releases/latest/download/AppleColorEmoji.ttf -O "${USER_HOME}/.local/share/fonts/AppleColorEmoji.ttf"

printf "${BOLD}${GREEN}Backing up existing /etc/fonts/conf.d/60-generic.conf if exists...${RESET}\n"
if [ -f /etc/fonts/conf.d/60-generic.conf ]; then
  cp /etc/fonts/conf.d/60-generic.conf /etc/fonts/conf.d/60-generic.conf.bak
fi

printf "${BOLD}${GREEN}Updating /etc/fonts/conf.d/60-generic.conf to prioritize Apple Color Emoji...${RESET}\n"
tee /etc/fonts/conf.d/60-generic.conf > /dev/null <<EOL
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

printf "${BOLD}${GREEN}Creating user fontconfig override for font preferences...${RESET}\n"
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

printf "${BOLD}${GREEN}Changing ownership of user's font files and config to the user...${RESET}\n"
chown -R "$(logname)":"$(logname)" "${USER_HOME}/.local/share/fonts"
chown -R "$(logname)":"$(logname)" "${USER_CONFIG_DIR}"

printf "${BOLD}${GREEN}Rebuilding font cache...${RESET}\n"
fc-cache -f -v

printf "\n${BOLD}${GREEN}Installation complete!${RESET}\n"
printf "${BOLD}Please restart your applications or logout/login to apply the font changes.${RESET}\n\n"

# Prompt user to restart now or not
printf "${BOLD}${GREEN}Would you like to restart your computer now? (y/n): ${RESET}"
read -r answer

case "$answer" in
  [Yy]* )
    printf "${BOLD}${GREEN}Restarting now...${RESET}\n"
    systemctl reboot
    ;;
  [Nn]* )
    printf "${BOLD}${GREEN}Restart canceled. Restart later to apply changes.${RESET}\n"
    ;;
  * )
    printf "${RED}Invalid input. Please restart manually later for changes to take effect.${RESET}\n"
    ;;
esac

