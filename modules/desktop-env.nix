{  pkgs, lib, config, ... }:
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

    dart-sass
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = readDirStr "/.dotfiles/hypr/";
  };

  programs.ags = {
    enable = true;
    configDir = ../.dotfiles/ags;
  };
}
