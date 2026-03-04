{
  inputs,
  pkgs,
  dotfiles,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./hyprpanel.nix
  ];

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
