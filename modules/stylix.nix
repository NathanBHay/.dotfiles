{
  pkgs,
  ...
}:
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
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      sizes.applications = 11;
    };

    cursor = {
      name = "Catppuccin-Mocha-Light-Cursors";
      package = pkgs.catppuccin-cursors.mochaLight;
      size = 24;
    };

    # Could maybe remove or find nicer icons
    icons = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };

    targets = {
      console.enable = false;
      grub.enable = false;
    };
  };
  boot.loader.grub.theme = pkgs.catppuccin-grub;
}
