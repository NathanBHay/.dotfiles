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
    rofi # Application Launcher
    super-productivity # Task Manager
    tor-browser # Anonymous Browser
    vesktop # Messaging
    zathura # PDF Viewer
    zotero # Research Manager

    # CLI Tools
    awww # Wallpaper
    brightnessctl # Control Brightness
    nodejs # For tree-sitter
    sops # Secret Manager
    tree-sitter # Syntax Highlighter
    usbutils # For bug fixing
    wayshot # Screenshot

    # Processes
    hyprlock # Screen Lock
    hypridle # Screen Idle
    hyprpanel
    hyprsunset # Blue Light Filter

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
