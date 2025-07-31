# 🍎 Apple Emoji Installer for Linux

Make your Linux system *look fabulous* with Apple Color Emoji!  
This script downloads and installs the Apple Color Emoji font and updates font configs for a seamless emoji experience across apps.

---

## ✨ Features

- 💻 Installs Apple Color Emoji on any Linux distro  
- ⚙️ Updates fontconfig to prioritize Apple emojis  
- 🛡️ Backs up existing config     

---


## 🛠️ Installation

1. Clone this repo or download the script:

```bash
git clone https://github.com/Aarnav-Tech/apple-emoji-installer.git
cd apple-emoji-installer
```

2. Make the script executable:

```bash
chmod a+x install_apple_emoji.sh
```

3. Run it with `sudo`:

```bash
sudo ./install_apple_emoji.sh
```

4. Reboot or log out/log in to apply changes.

5. [Optional] Delete The Folder after installing

   ```bash
   rm -rf /apple-color-emoji-installer
   ```

---

## 📂 What this script does

* Downloads [`AppleColorEmoji.ttf`](https://github.com/samuelngs/apple-emoji-linux) to your fonts folder  
* Installs it to `~/.local/share/fonts`  
* Adds fontconfig aliases to prefer Apple Emoji  
* Creates or overwrites `/etc/fonts/conf.d/60-generic.conf`  
* Adds per-user override in `~/.config/fontconfig/fonts.conf`  
* Rebuilds the system font cache  
* Prompts to restart your computer  

---

## 🔒 Notes

* If `/etc/fonts/conf.d/60-generic.conf` exists, it will be backed up as `60-generic.conf.bak`.  
* Fonts are installed to the **user's home directory**, even when run with `sudo`.

---

## 📃 License

This project is licensed under the [MIT License](LICENSE).

---

## 🤝 Credits

* Emoji font from [samuelngs/apple-emoji-linux](https://github.com/samuelngs/apple-emoji-linux)  
* Script by Aarnav

---

Enjoy your 🍏 emojis on 🐧 Linux!
