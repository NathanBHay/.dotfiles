{  pkgs, lib, config, ... }:
{
  home.packages = with pkgs; [
    hyprland
    waybar
    dunst # TODO: rice
    libnotify
    sddm
    rofi-wayland
  ];

  # Hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
