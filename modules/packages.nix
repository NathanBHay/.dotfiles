{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    ark          # Archieve Previewer
    bitwarden    # Password Manager
    brave        # Browser
    discord      # Messaging
    dolphin      # File Explorer
    flameshot    # Screenshot
    kitty        # Terminal Emulator
    # megasync     # Drive Sync
    mpv          # Media Player
    neovim       # Text Editor
    obsidian     # Notes App
    qbittorrent  # Torrent Client

    # Shell
    zsh
    zsh-autosuggestions
    zsh-fzf-tab
    zsh-powerlevel10k
    zsh-syntax-highlighting

    # CLI Tools
    aspell      # Spell Correction
    bat         # Cat Replacment
    dust        # Folder Storage
    efibootmgr  # Boot Entry Manager
    eza         # Ls Replacement
    fd          # Find Replacement
    fzf         # Fuzzy-Finder
    git         # Version Control
    gzip        # Expanded Zip
    htop        # Resource Monitor
    lazygit     # Git GUI
    neofetch    # Fetch
    ripgrep     # Recursive Grep
    unzip       # Normal Zip
    wget        # Internet Download
    zoxide      # CD Replacement

    # Compilers
    gcc     # C++ Compiler
    cargo   # Rust Package Manager
    nodejs  # JS Backend

    # Fonts
    noto-fonts
    fira
    ibm-plex
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.fontconfig.enable = true;
}
