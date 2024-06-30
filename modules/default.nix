{ config, pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./desktop-env.nix
    ./symlinks.nix
  ];
}
