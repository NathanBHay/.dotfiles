{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModule
    inputs.ags.homeManagerModules.default
    ./packages.nix
    ./symlinks.nix
    ./theme.nix
  ];
}
