{
  inputs,
  pkgs,
  config,
  dotfiles,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  c = config.lib.stylix.colors;
in
{
  imports = [
    ./hyprpanel.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    extraConfig = ''
      source = ${dotfiles}/hypr/hyprland.conf
      source = ${dotfiles}/hypr/bindings.conf
      general {
         col.active_border = 0xbb${c.base0D} 0xaa${c.base0E} 45deg
         col.inactive_border = 0xff${c.base01}
      }
    '';
  };

  programs = {
    bat.enable = true;
    btop.enable = true;
    kitty.enable = true;
    kitty.extraConfig = builtins.readFile "${dotfiles}/kitty.conf";
    mpv.enable = true;
    rofi.enable = true;
    spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        keyboardShortcut
        songStats
      ];
    };
    vesktop.enable = true;
    yazi.enable = true;
    hyprpanel.enable = true;
  };
}
