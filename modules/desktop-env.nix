{  pkgs, lib, config, ... }:
with builtins;
let
  readFileRel = x: readFile (../. + x);
  readDirList = x: attrNames (readDir  (../. + x));
  readDirStr = x: foldl' (y: z: y + readFileRel (x + z)) "\n" (readDirList x);
in {
  home.packages = with pkgs; [
    brightnessctl # Control Brightness
    playerctl     # Control media players
    swww          # Wallpaper
    libnotify
    sddm
    rofi-wayland
    wluma

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
