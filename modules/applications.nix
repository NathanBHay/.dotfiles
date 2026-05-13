{
  pkgs,
  inputs,
  dotfiles,
  ...
}:
let
  hyprConf = x: "${dotfiles}/hypr/${x}.conf";
in
{
  imports = [ inputs.zen-browser.homeModules.default ];
  home.packages = with pkgs; [
    # Apps
    kitty # Terminal Emulator
    megacmd # Drive Sync
    mpv # Media Player
    obsidian # Notes App
    pavucontrol # Audio Control
    qalculate-qt # Calculator
    qbittorrent # Torrent Client
    rofi # Application Launcher
    super-productivity # Task Manager
    tor-browser # Anonymous Browser
    vesktop # Messaging
    zathura # PDF Viewer
    zotero # Research Manager

    # CLI Tools
    brightnessctl # Control Brightness
    opencode # AI Agent
    pdfannots2json # For Obsidian Zotero Plugin
    sops
    # swappy # Screenshot Modifier
    awww # Wallpaper
    wayshot # Screenshot

    # Processes
    hyprlock # Screen Lock
    hypridle # Screen Idle
    hyprpanel
    hyprsunset # Blue Light Filter

    # Compilers
    bun # JS Bundler
    dart-sass # CSS Compiler
    nodejs # JS Backend
    tree-sitter # Syntax Highlighter

    # Fonts
    ibm-plex
  ];

  fonts.fontconfig.enable = true;

  programs.zen-browser.enable = true;

  # Configs located in $HOME
  home.file."Pictures/.avatar.jpg".source = "${dotfiles}/.avatar.jpg";

  # Configs located in .config
  xdg.configFile = {
    "hypr/hypridle.conf".source = hyprConf "hypridle";
    "hypr/hyprlock.conf".source = hyprConf "hyprlock";
    "hypr/hyprsunset.conf".source = hyprConf "hyprsunset";
  };
}
