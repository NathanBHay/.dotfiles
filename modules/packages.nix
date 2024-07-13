{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    ark          # Archive Previewer
    bitwarden    # Password Manager
    brave        # Browser
    vesktop      # Messaging
    dolphin      # File Explorer
    flameshot    # Screenshot
    kdePackages.kdegraphics-thumbnailers
    kitty        # Terminal Emulator
    megasync     # Drive Sync
    mpv          # Media Player
    neovim       # Text Editor
    obsidian     # Notes App
    qbittorrent  # Torrent Client

    # Themes
    papirus-folders                   # Icon Pack
    libsForQt5.qt5ct                  # QT5
    libsForQt5.qtstyleplugin-kvantum  # QT5 Theme

    # Shell
    zsh                      # Shell
    zsh-autosuggestions      # Shell Recommendations
    zsh-fzf-tab              # Shell FZF Integration
    zsh-powerlevel10k        # Shell theme
    zsh-syntax-highlighting  # Shell highlights

    # CLI Tools
    aspell        # Spell Correction
    bat           # Cat Replacment
    btop          # Resource Monitor
    cliphist      # Clipboard History
    dust          # Folder Storage
    efibootmgr    # Boot Entry Manager
    eza           # Ls Replacement
    fd            # Find Replacement
    fzf           # Fuzzy-Finder
    git           # Version Control
    grim          # Screenshot
    gzip          # Expanded Zip
    lazygit       # Git GUI
    neofetch      # Fetch
    ripgrep       # Recursive Grep
    slurp         # Screenshot Area Selector
    swappy        # Screenshot Modifier
    unzip         # Normal Zip
    wget          # Internet Download
    wl-clipboard  # Clipboard Manager
    zoxide        # CD Replacement

    # Compilers
    gcc     # C++ Compiler
    cargo   # Rust Package Manager
    nodejs  # JS Backend

    # Fonts
    noto-fonts
    fira
    ibm-plex
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
  ];

  fonts.fontconfig.enable = true;
  services.megasync.enable = true;
}
