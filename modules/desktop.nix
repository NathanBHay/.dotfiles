{ pkgs, inputs, dotfiles, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
    inputs.ags.homeManagerModules.default
  ];
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

    # CLI Tools
    brightnessctl # Control Brightness
    slurp         # Screenshot Area Selector
    swappy        # Screenshot Modifier
    swww          # Wallpaper
    wayshot       # Screenshot

    # Processes
    hyprlock  # Screen Lock
    hypridle  # Screen Idle

    # Compilers
    bun           # JS Bundler
    dart-sass     # CSS Compiler
    nodejs        # JS Backend

    # Fonts
    fira
    ibm-plex
    noto-fonts
  ];

  fonts.fontconfig.enable = true;

  # Symlinks
  programs.ags = {
    enable = true;
    configDir = "${dotfiles}/ags";
  };

  # Configs located in .config
  xdg.configFile = {
    hypr.source = "${dotfiles}/hypr";
    kitty.source = "${dotfiles}/kitty";
    swappy.source = "${dotfiles}/swappy";
    "vesktop/themes/custom.css".source = "${dotfiles}/vesktop/custom.css";
  };
}
