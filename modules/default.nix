{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModule
    ./packages.nix
    ./desktop-env.nix
    ./symlinks.nix
    ./theme.nix
  ];
}
