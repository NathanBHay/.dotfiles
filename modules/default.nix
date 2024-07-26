{ inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.spicetify-nix.homeManagerModules.default
    inputs.ags.homeManagerModules.default
    ./packages.nix
    ./symlinks.nix
    ./theme.nix
  ];
}
