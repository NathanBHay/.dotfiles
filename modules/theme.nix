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
    inputs.spicetify-nix.homeManagerModules.default
    ./hyprpanel.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    extraConfig = ''
      require 'visuals'
      require 'bindings'
      hl.config {
        general = {
          col = {
            active_border = {
              colors = {'0xbb${c.base0D}', '0xaa${c.base0E}'},
              angle = 45,
            },
            inactive_border = '0xff${c.base01}',
          },
        },
      }
    '';
  };

  gtk.gtk4.theme = null; # Suppress Warning

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
    zathura.enable = true;
  };

  xdg.configFile = {
    "rofi/rofi.rasi".source = "${dotfiles}/rofi.rasi";
    "hypr/visuals.lua".source = "${dotfiles}/hypr/hyprland.lua";
    "hypr/bindings.lua".source = "${dotfiles}/hypr/bindings.lua";
  };
  stylix.targets.zen-browser.profileNames = [ "Default Profile" ];
}
