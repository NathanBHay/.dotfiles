# CachyOS Migration Commands

This is a command runbook for moving this machine from NixOS to CachyOS while
keeping Nix for development shells and user-level packages.

It is based on the current `NathanLaptop` host. Desktop-only extras from
`hosts/desktop/default.nix` are in their own section.

References checked 2026-05-29:

- https://nix.dev/install-nix.html
- https://archlinux.org/packages/extra/x86_64/nix/
- https://wiki.cachyos.org/cachyos_basic/faq/

## Current NixOS Parity Targets

- User: `nathan`
- Hostname: `NathanLaptop`
- Timezone: `Europe/Berlin`
- Locale: `en_AU.UTF-8`
- Shell: `zsh`
- Desktop: Hyprland + SDDM + XWayland
- Audio: PipeWire, WirePlumber, ALSA, Pulse, JACK, RTKit
- Services: NetworkManager, Bluetooth, OpenSSH, NextDNS, Avahi, GVFS, UDisks2
- Laptop services: TLP, powertop, upower, Mullvad VPN, Kanata, Logitech/QMK tools
- Nix features: `nix-command` and `flakes`
- Main config repo path: `~/.nixos`

## 0. Before Reinstalling NixOS

Run these on the current NixOS install before wiping anything.

```sh
mkdir -p ~/migration-backup

cp -a ~/.nixos ~/migration-backup/nixos-config
cp -a ~/.ssh ~/migration-backup/ssh
cp -a ~/.config/.agekey ~/migration-backup/agekey
cp -a ~/.zsh_history ~/migration-backup/zsh_history

nix flake metadata ~/.nixos
nix flake metadata ~/.nixos/shells
sudo nixos-rebuild build --flake ~/.nixos#NathanLaptop
```

If this repository is not already pushed somewhere private, copy
`~/migration-backup` to external storage before reinstalling.

## 1. First Boot On CachyOS

```sh
sudo cachyos-rate-mirrors
sudo pacman -Syu

sudo pacman -S --needed base-devel git curl wget jq less vim

sudo hostnamectl set-hostname NathanLaptop
sudo timedatectl set-timezone Europe/Berlin
sudo localectl set-locale LANG=en_AU.UTF-8
sudo localectl set-keymap us
sudo localectl set-x11-keymap au
```

Create or update the user groups. CachyOS/Arch uses `libvirt`; the old NixOS
config used `libvirtd`.

```sh
getent group uinput >/dev/null || sudo groupadd uinput
sudo usermod -aG wheel,video,audio,lp,scanner,libvirt,uinput nathan
```

Log out and back in after changing groups.

## 2. Install Native System Packages

Keep system services, drivers, display-manager pieces, portals, and hardware
tools native to CachyOS. Use Nix mostly for user tools and dev shells.

```sh
sudo pacman -S --needed \
  networkmanager bluez bluez-utils \
  pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber rtkit \
  openssh gvfs udisks2 avahi nfs-utils zram-generator \
  zsh zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-tab zsh-theme-powerlevel10k \
  direnv nix-direnv \
  hyprland xorg-xwayland xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  sddm qt5-wayland qt6-wayland rofi kitty mpv pavucontrol qalculate-qt zathura \
  brightnessctl playerctl wl-clipboard wayshot hyprlock hypridle hyprsunset \
  ttf-firacode-nerd ttf-fira-mono-nerd ttf-ibm-plex noto-fonts noto-fonts-emoji papirus-icon-theme \
  aspell bat btop dust eza fd fzf lazygit libqalculate lsof fastfetch neovim nmap onefetch \
  ripgrep sops age tldr trash-cli unzip zip usbutils yazi zoxide gcc cmake nodejs tree-sitter \
  tlp powertop upower solaar qmk mullvad-vpn
```

Optionally for video games
```sh
sudo pacman -S steam gamemode lib32-gamemode prismlauncher jdk-openjdk
```

Install AUR/Cachy packages for things that may not be in the official Arch
repositories. Review PKGBUILDs when prompted.

```sh
command -v paru >/dev/null || sudo pacman -S --needed paru

paru -S --needed \
  nextdns \
  kanata \
  qmk-udev-rules \
  via-bin \
  megasync \
  zen-browser-bin \
  vesktop \
  obsidian \
  zotero \
  torbrowser-launcher \
  superproductivity-bin \
  hyprpanel \
  awww \
  bluetui \
  catppuccin-cursors-mocha
```

If a package has moved into the official repositories, install it with
`sudo pacman -S --needed <package>` instead.

## 3. Enable System Services

```sh
sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now sshd
sudo systemctl enable --now avahi-daemon
sudo systemctl enable --now udisks2
sudo systemctl enable --now sddm

systemctl --user enable --now pipewire pipewire-pulse wireplumber

sudo systemctl enable --now fstrim.timer
sudo systemctl enable --now mullvad-daemon
```

TLP commonly conflicts with `power-profiles-daemon`; disable the latter if it
exists.

```sh
sudo systemctl disable --now power-profiles-daemon 2>/dev/null || true
sudo systemctl enable --now tlp
sudo systemctl enable --now upower
```

Set `zram` to the NixOS value of 25% RAM.

```sh
sudo tee /etc/systemd/zram-generator.conf >/dev/null <<'EOF'
[zram0]
zram-size = ram / 4
compression-algorithm = zstd
EOF

sudo systemctl daemon-reload
sudo systemctl start systemd-zram-setup@zram0.service
```

## 4. Configure SDDM Autologin To Hyprland

This matches the NixOS `services.displayManager.autoLogin` setting.

```sh
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null <<'EOF'
[Autologin]
User=nathan
Session=hyprland
EOF
```

## 5. Install Nix

Recommended upstream multi-user install:

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install -o /tmp/nix-install.sh
less /tmp/nix-install.sh
sh /tmp/nix-install.sh --daemon
```

Then configure flakes, wheel access, and the old `warn-dirty = false` behavior:

```sh
sudo mkdir -p /etc/nix
sudo tee /etc/nix/nix.conf >/dev/null <<'EOF'
experimental-features = nix-command flakes
allowed-users = @wheel
trusted-users = root @wheel nathan
warn-dirty = false
auto-optimise-store = true
EOF

sudo systemctl enable --now nix-daemon
sudo systemctl restart nix-daemon
```

Alternative Arch-packaged Nix install:

```sh
sudo pacman -S --needed nix
sudo systemctl enable --now nix-daemon
```

Use only one of the two Nix install paths.

## 6. Restore This Repository

Use your real remote URL if the repository is private.

```sh
git clone <repo-url> ~/.nixos
cd ~/.nixos
nix flake metadata .
nix flake metadata ./shells
```

Restore secrets copied before reinstalling:

```sh
mkdir -p ~/.config
cp -a ~/migration-backup/agekey ~/.config/.agekey
chmod 600 ~/.config/.agekey
```

## 7. NextDNS

This extracts the encrypted `nextdns` value from `dotfiles/.secrets.json`, then
installs the daemon with the old cache size.

```sh
NEXTDNS_PROFILE="$(SOPS_AGE_KEY_FILE=~/.config/.agekey sops -d --extract '["nextdns"]' ~/.nixos/dotfiles/.secrets.json)"

sudo nextdns install \
  -profile "$NEXTDNS_PROFILE" \
  -cache-size 10MB

sudo systemctl enable --now nextdns
nextdns status
```

If NetworkManager overwrites DNS unexpectedly, re-run `sudo nextdns activate`.

## 8. Kanata Caps/Escape Mapping

```sh
sudo modprobe uinput
echo uinput | sudo tee /etc/modules-load.d/uinput.conf >/dev/null

sudo tee /etc/udev/rules.d/99-uinput.rules >/dev/null <<'EOF'
KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger

sudo mkdir -p /etc/kanata
sudo cp ~/.nixos/dotfiles/kanata.kbd /etc/kanata/internal.kbd

sudo tee /etc/systemd/system/kanata-internal.service >/dev/null <<'EOF'
[Unit]
Description=Kanata internal keyboard remap
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/kanata --cfg /etc/kanata/internal.kbd --device /dev/input/by-path/platform-i8042-serio-0-event-kbd
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now kanata-internal.service
```

## 9. Dotfiles Without Home Manager

Use this fallback if you have not yet added a standalone Home Manager output to
the flake.

```sh
mkdir -p ~/.config/hypr ~/.config/kitty ~/.config/rofi ~/.config/direnv ~/.config/git ~/.ssh ~/Pictures

ln -snf ~/.nixos/dotfiles/zshrc.sh ~/.zshrc
ln -snf ~/.nixos/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -snf ~/.nixos/dotfiles/ssh/config ~/.ssh/config
ln -snf ~/.nixos/dotfiles/gdbinit ~/.gdbinit
ln -snf ~/.nixos/dotfiles/git/.gitconfig ~/.gitconfig
ln -snf ~/.nixos/dotfiles/git/.gitignore ~/.config/.gitignore
ln -snf ~/.nixos/dotfiles/direnv.toml ~/.config/direnv/direnv.toml
ln -snf ~/.nixos/dotfiles/nvim ~/.config/nvim
ln -snf ~/.nixos/dotfiles/kitty.conf ~/.config/kitty/kitty.conf
ln -snf ~/.nixos/dotfiles/rofi.rasi ~/.config/rofi/rofi.rasi
ln -snf ~/.nixos/dotfiles/hypr/hypridle.conf ~/.config/hypr/hypridle.conf
ln -snf ~/.nixos/dotfiles/hypr/hyprlock.conf ~/.config/hypr/hyprlock.conf
ln -snf ~/.nixos/dotfiles/hypr/hyprsunset.conf ~/.config/hypr/hyprsunset.conf
ln -snf ~/.nixos/dotfiles/hypr/hyprland.lua ~/.config/hypr/visuals.lua
ln -snf ~/.nixos/dotfiles/hypr/bindings.lua ~/.config/hypr/bindings.lua
ln -snf ~/.nixos/dotfiles/.avatar.jpg ~/Pictures/.avatar.jpg

chmod 600 ~/.ssh/config
```

The current Hyprland config is generated by Home Manager with `configType =
"lua"`. Until that is ported to standalone Home Manager, create a minimal
Hyprland entrypoint so the session at least launches. This is not full Hyprland
parity; use standalone Home Manager for that, or port `dotfiles/hypr/*.lua` to
plain `hyprland.conf`.

```sh
tee ~/.config/hypr/hyprland.conf >/dev/null <<'EOF'
# Temporary CachyOS entrypoint. Prefer standalone Home Manager for full parity.
exec-once = hyprlock
exec-once = hypridle
exec-once = hyprpanel
exec-once = awww-daemon
exec-once = hyprsunset
exec-once = sleep 5 && mega-sync

env = XCURSOR_SIZE,24
env = HYPRCURSOR_SIZE,24
env = XDG_CURRENT_DESKTOP,Hyprland
EOF
```

Generate `~/.zshsrc`, which Home Manager previously generated from
`modules/functions.nix`.

```sh
cat > ~/.zshsrc <<'EOF'
export dotfiles_shell=~/.nixos/shells#dotfiles
export zip_shell=~/.nixos/shells#zip
export python_shell=~/.nixos/shells#python
export rust_shell=~/.nixos/shells#rust
export cpp_shell=~/.nixos/shells#cpp
export js_shell=~/.nixos/shells#js
export cryptopt_shell=~/.nixos/shells#cryptopt
export write_shell=~/.nixos/shells#write
export neuralnet_shell=~/.nixos/shells#neuralnet
export ags_shell=~/.nixos/shells#ags
export constraint_shell=~/.nixos/shells#constraint
export game_shell=~/.nixos/shells#game
export java_shell=~/.nixos/shells#java
export sagemath_shell=~/.nixos/shells#sagemath
export webscrape_shell=~/.nixos/shells#webscrape

_envrc_shell() {
  local shell_var="${1}_shell"
  local shell_ref="${(P)shell_var}"
  printf '%s\n' \
    "use flake ${shell_ref}" \
    "if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then" \
    "  onefetch -d churn" \
    "fi" > .envrc
}

for name in dotfiles zip python rust cpp js cryptopt write neuralnet ags constraint game java sagemath webscrape; do
  shell_var="${name}_shell"
  alias "nix-${name}=nix develop ${(P)shell_var} -c zsh"
  alias "envrc-${name}=_envrc_shell ${name}"
done
unset name shell_var

[[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -r /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh ]] && source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
[[ -r /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]] && source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ -r ~/.nixos/shells/shellcommands.sh ]] && source ~/.nixos/shells/shellcommands.sh
EOF
```

Set `zsh` as the login shell.

```sh
chsh -s /usr/bin/zsh nathan
```

## 10. Preferred Standalone Home Manager Path

This is the cleaner long-term path. The root flake now exposes a standalone
Home Manager output for `nathan@NathanLaptop`:

```sh
nix run github:nix-community/home-manager -- switch --flake ~/.nixos#nathan@NathanLaptop
```

After that, the manual dotfile symlinks and generated `~/.zshsrc` fallback above
are not needed.

## 11. Nix Dev Shell Checks

```sh
nix develop ~/.nixos/shells#dotfiles -c zsh -lc 'nixfmt --version && stylua --version'
nix develop ~/.nixos/shells#python -c zsh -lc 'python --version && pyright --version'
nix develop ~/.nixos/shells#rust -c zsh -lc 'rustc --version && cargo --version'
nix develop ~/.nixos/shells#cpp -c zsh -lc 'gcc --version | head -n1 && gdb --version | head -n1'
nix develop ~/.nixos/shells#js -c zsh -lc 'node --version && tsc --version'
```

## 12. Desktop-Only Extras

Run only on the desktop host.

```sh
sudo pacman -S --needed v4l-utils openrgb
paru -S --needed streamdeck-ui

sudo systemctl enable --now openrgb
```

AMD graphics and 32-bit Vulkan/Mesa are normally handled by CachyOS if selected
during install. If Steam or games complain, check these packages:

```sh
sudo pacman -S --needed mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
```

## 13. Verification

```sh
groups nathan
systemctl status NetworkManager bluetooth sshd avahi-daemon udisks2 sddm tlp nextdns
systemctl --user status pipewire pipewire-pulse wireplumber
nix --version
nix flake metadata ~/.nixos
hyprctl version
nextdns status
mullvad status
```

After reboot:

```sh
reboot
```
