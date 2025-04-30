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
    inputs.catppuccin.homeModules.catppuccin
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
    ticktick # Calendar
    tor-browser # Anonymous Browser
    zotero-beta # Research Manager

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
  home.file = {
    "${obsidianVaultConf}" = {
      source = "${dotfiles}/obsidian";
      recursive = true;
    };
    "${obsidianVault}/Zotero Template.md".source = "${dotfiles}/obsidian/zotero-template.md";
    "${obsidianVaultConf}/plugins/obsidian-zotero-desktop-connector/pdfannots2json".source =
      "${pkgs.pdfannots2json}/bin/pdfannots2json";
  };

  # Configs located in .config
  xdg.configFile = {
    albert.source = "${dotfiles}/albert";
    hypr.source = "${dotfiles}/hypr";
    "hyprpanel/config.json".source = "${dotfiles}/hyprpanel_conf.json";
    kitty.source = "${dotfiles}/kitty";
    swappy.source = "${dotfiles}/swappy";
    "vesktop/themes/custom.css".source = "${dotfiles}/vesktop/custom.css";
  };
}
