{
  pkgs,
  config,
  ...
}:
let
  c = config.lib.stylix.colors;
in
{
  # Theming
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    override = {
      base02 = "#313244"; # base02 = base01 to make elements darker
    };

    polarity = "dark";

    opacity = {
      applications = 0.9;
      terminal = 0.9;
      popups = 0.9;
      desktop = 0.9;
    };

    fonts = {
      monospace = {
        name = "FiraCode Nerd Font";
      };

      sizes.applications = 11;
    };

    icons.enable = false;

    targets = {
      bat.enable = true;
      blender.enable = false;
      btop.enable = true;
      font-packages.enable = false;
      gnome.enable = false;
      gtk.enable = true;
      hyprland.enable = true;
      hyprpanel.enable = true;
      kde.enable = false;
      kitty.enable = true;
      mpv.enable = true;
      qt.enable = false;
      rofi.enable = true;
      vesktop.enable = true;
      xresources.enable = false;
      yazi.enable = true;
      zathura.enable = true;
    };
  };
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

}
