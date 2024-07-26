{ inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in {
  programs = {
    btop = {
      enable = true;
      catppuccin.enable = true;
    };
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
  catppuccin.pointerCursor = {
    enable = true;
    accent = "light";
  };
  qt = {
    enable = true;
    style.name = "kvantum";
    style.catppuccin.enable = true;
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
