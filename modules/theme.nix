{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  programs = {
    spicetify = {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
      enabledExtensions = with spicePkgs.extensions; [
        keyboardShortcut
        songStats
      ];
    };
  };
  catppuccin = {
    btop.enable = true;
    cursors = {
      enable = true;
      accent = "light";
    };
    kvantum.enable = true;
    gtk.enable = true;
    mpv.enable = true;
  };
  # TODO: Perhaps delete this part?
  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
  };
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };
}
