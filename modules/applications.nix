{
  pkgs,
  inputs,
  dotfiles,
  ...
}:
let
  obsidianVault = "MEGA/Obsidian Vault/";
  obsidianVaultConf = "${obsidianVault}.obsidian/";
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  home.packages = with pkgs; [
    # Apps
    rofi # Application Launcher
    brave # Browser
    vesktop # Messaging
    flameshot # Screenshot
    kitty # Terminal Emulator
    megacmd # Drive Sync
    mpv # Media Player
    obsidian # Notes App
    pavucontrol # Audio Control
    qalculate-qt # Calculator
    qbittorrent # Torrent Client
    ticktick # Calendar
    tor-browser # Anonymous Browser
    zotero # Research Manager

    # CLI Tools
    brightnessctl # Control Brightness
    pdfannots2json # For Obsidian Zotero Plugin
    slurp # Screenshot Area Selector
    swappy # Screenshot Modifier
    swww # Wallpaper
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

  # Configs located in $HOME
  home.file = {
    "${obsidianVaultConf}" = {
      source = "${dotfiles}/obsidian";
      recursive = true;
    };
    "${obsidianVault}/Zotero Template.md".source = "${dotfiles}/obsidian/zotero-template.md";
    "${obsidianVaultConf}/plugins/obsidian-zotero-desktop-connector/pdfannots2json".source =
      "${pkgs.pdfannots2json}/bin/pdfannots2json";
    "Pictures/.avatar.jpg".source = "${dotfiles}/.avatar.jpg";
  };

  # Configs located in .config
  xdg.configFile = {
    hypr.source = "${dotfiles}/hypr";
    swappy.source = "${dotfiles}/swappy";
  };
}
