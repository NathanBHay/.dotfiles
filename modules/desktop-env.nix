{ pkgs, dotfiles, ... }:
with (import ./functions.nix);
{
  home.packages = with pkgs; [
    brightnessctl # Control Brightness
    playerctl     # Control media players
    swww          # Wallpaper
    sddm
    wluma
    hyprlock
    pavucontrol

    bun           # JS Bundler
    dart-sass     # AGS Style Sheets
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = readDirStr "/dotfiles/hypr/";
  };

  programs.ags = {
    enable = true;
    configDir = "${dotfiles}/ags";
  };
}
