## 1. First Boot On CachyOS
sudo cachyos-rate-mirrors
sudo pacman -Syu

sudo pacman -S --needed git curl wget vim

# sudo hostnamectl set-hostname NathanLaptop
sudo timedatectl set-timezone Europe/Berlin
# sudo localectl set-locale LANG=en_AU.UTF-8
# sudo localectl set-keymap us
# sudo localectl set-x11-keymap au

# Main packages
sudo pacman -S --needed \
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-tab zsh-theme-powerlevel10k \
  openssh gvfs avahi nfs-utils keychain \
  mpv mpv-mpris \
  qalculate-qt zathura zathura-pdf-mupdf \
  brightnessctl direnv \
  ttf-firacode-nerd ttf-fira-mono-nerd ttf-ibm-plex \
  aspell bat btop dust eza fd fzf lazygit libqalculate lsof fastfetch neovim \
  nmap onefetch ripgrep tldr trash-cli jq zip usbutils yazi zoxide \
  gcc cmake nodejs tree-sitter tree-sitter-cli \
  powertop upower solaar mullvad-vpn \
  qt6ct \
  nextdns \
  vesktop \
  obsidian \
  zotero \
  adw-gtk-theme \
  bluetui

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'

# Paru Packages
paru -S --needed \
  brave-origin-beta-bin \
  fzf-tab \
  mega-cmd \
  torbrowser-launcher \
  superproductivity-bin \
  spotify \
  spicetify \
  catppuccin-cursors-mocha # kanata-bin \

## Restore repository and stow
cd ~ || exit
git clone git@github.com:NathanBHay/.dotfiles.git
stow ~/.dotfiles/dotfiles

# might need to run sudo groupadd uinput
sudo groupadd uinput
sudo usermod -a -G uinput nathan
sudo tee /etc/udev/rules.d/99-input.rules >/dev/null <<EOF
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF

## 3. Enable System Services
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now sshd
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now sddm
systemctl --user enable --now pipewire pipewire-pulse wireplumber
sudo systemctl enable --now fstrim.timer

sudo systemctl enable --now mullvad-daemon
sudo systemctl enable --now nix-daemon.service

## 7. NextDNS

sudo nextdns config set -profile=...

sudo tee /etc/sddm.conf >/dev/null <<'EOF'
[Autologin]
User=nathan
Session=hyprland
EOF

# Spicetify
# Write to spotify directory
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify apply
