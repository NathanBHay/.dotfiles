{ pkgs, dotfiles, ... }:
{
  home.packages = with pkgs; [
    # Apps
    ark          # Archive Previewer
    bitwarden    # Password Manager
    brave        # Browser
    vesktop      # Messaging
    flameshot    # Screenshot
    kitty        # Terminal Emulator
    megasync     # Drive Sync
    mpv          # Media Player
    neovim       # Text Editor
    obsidian     # Notes App
    qbittorrent  # Torrent Client
    zotero-beta  # Research Manager
    networkmanagerapplet

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
    brightnessctl # Control Brightness
    btop          # Resource Monitor
    cliphist      # Clipboard History
    dust          # Folder Storage
    efibootmgr    # Boot Entry Manager
    eza           # Ls Replacement
    fd            # Find Replacement
    fzf           # Fuzzy-Finder
    gzip          # Expanded Zip
    lazygit       # Git GUI
    neofetch      # Fetch
    nmap          # Internet Scanner
    pavucontrol   # Audio Control
    playerctl     # Control media players
    ripgrep       # Recursive Grep
    slurp         # Screenshot Area Selector
    swappy        # Screenshot Modifier
    swww          # Wallpaper
    trash-cli     # Trash
    tldr          # Help Pages
    unzip         # Normal Zip
    wayshot       # Screenshot
    wget          # Internet Download
    wl-clipboard  # Clipboard Manager
    yazi          # File Explorer
    zip           # Compression
    zoxide        # CD Replacement

    # Processes
    hyprlock  # Screen Lock
    hypridle  # Screen Idle

    # Compilers
    bun           # JS Bundler
    dart-sass     # CSS Compiler
    gcc           # C++ Compiler
    nodejs        # JS Backend

    # Fonts
    noto-fonts
    fira
    ibm-plex
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" ]; })
  ];

  fonts.fontconfig.enable = true;

  programs.ags = {
    enable = true;
    configDir = "${dotfiles}/ags";
  };
}
