{ pkgs, inputs, dotfiles, ... }: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    # Apps
    albert # Application Launcher
    bitwarden # Password Manager
    brave # Browser
    vesktop # Messaging
    flameshot # Screenshot
    kitty # Terminal Emulator
    megasync # Drive Sync
    mpv # Media Player
    neovim # Text Editor
    obsidian # Notes App
    pavucontrol # Audio Control
    qalculate-qt # Calculator
    qbittorrent # Torrent Client
    zotero-beta # Research Manager

    # CLI Tools
    brightnessctl # Control Brightness
    slurp # Screenshot Area Selector
    swappy # Screenshot Modifier
    swww # Wallpaper
    wayshot # Screenshot

    # Processes
    hyprlock # Screen Lock
    hypridle # Screen Idle

    # Compilers
    bun # JS Bundler
    dart-sass # CSS Compiler
    nodejs # JS Backend

    # Fonts
    fira
    ibm-plex
    noto-fonts
  ];

  fonts.fontconfig.enable = true;

  # Configs located in $HOME
  home.file."MEGA/Obsidian Vault/.obsidian" = {
    source = "${dotfiles}/obsidian";
    recursive = true;
  };

  # Configs located in .config
  xdg.configFile = {
    albert.source = "${dotfiles}/albert";
    hypr.source = "${dotfiles}/hypr";
    kitty.source = "${dotfiles}/kitty";
    swappy.source = "${dotfiles}/swappy";
    "vesktop/themes/custom.css".source = "${dotfiles}/vesktop/custom.css";
  };
}
