# 🍎 Apple Emoji Installer for Linux
Make your Linux system 𝓁𝑜𝑜𝓀 𝒻𝒶𝒷𝓊𝓁𝑜𝓊𝓈 with Apple Color Emoji!  
This script downloads and installs the Apple Color Emoji font and updates font configs for a seamless emoji experience across apps.

---

## ✨ Features

- 💻 Installs Apple Color Emoji on any Linux distro
- ⚙️ Updates fontconfig to prioritize Apple emojis
- 🛡️ Backs up existing config before making changes
- 🔁 Includes an uninstall script to fully revert changes
- 🌐 Works with both `curl` and `wget` — whichever is available

---

## 🖼️ Preview

Here's what your system will look like after installing Apple Emoji:

<p align="center">
  <img src="assets/apple-preview.png" alt="Apple Emoji Preview" width="1000"/>
</p>

---

## 🛠️ Installation

1. Clone this repo or download the script:
   ```bash
   git clone https://github.com/Aarnav-Tech/apple-emoji-installer.git
   cd apple-emoji-installer
   ```

2. Make the scripts executable:
   ```bash
   chmod a+x install_apple_emoji.sh uninstall_apple_emoji.sh
   ```

3. Run the installer with `sudo`:
   ```bash
   sudo ./install_apple_emoji.sh
   ```

4. Reboot or log out and back in to apply changes.

5. *(Optional)* Delete the folder after installing:
   ```bash
   cd .. && rm -rf apple-emoji-installer
   ```

---

## 🗑️ Uninstallation

To fully remove Apple Color Emoji and revert all font config changes:

```bash
sudo ./uninstall_apple_emoji.sh
```

The uninstaller will:
- Remove `AppleColorEmoji.ttf` from your fonts folder
- Restore the backed-up `/etc/fonts/conf.d/60-generic.conf`, or remove it if no backup exists
- Remove the per-user `~/.config/fontconfig/fonts.conf` override
- Rebuild the font cache
- Prompt to restart your computer

---

## 📂 What the install script does

- Downloads [`AppleColorEmoji-Linux.ttf`](https://github.com/samuelngs/apple-emoji-ttf) to `~/.local/share/fonts`
- Updates `/etc/fonts/conf.d/60-generic.conf` to prioritize Apple Emoji system-wide
- Adds a per-user override at `~/.config/fontconfig/fonts.conf`
- Rebuilds the system font cache
- Prompts to restart your computer

---

## 🔒 Notes

- If `/etc/fonts/conf.d/60-generic.conf` already exists, it is backed up as `60-generic.conf.bak` before being overwritten. The uninstaller will restore this backup automatically.
- Fonts are installed to the **invoking user's home directory**, even when run with `sudo`.
- Both `curl` and `wget` are supported. The installer will use whichever is available, and error out clearly if neither is found.

---

## 📃 License

This project is licensed under the [MIT License](LICENSE).

---

## 🤝 Credits

- Emoji font from [samuelngs/apple-emoji-ttf](https://github.com/samuelngs/apple-emoji-ttf)
- Script by [Aarnav](https://github.com/Aarnav-Tech)

---

Enjoy your 🍏 emojis on 🐧 Linux!
