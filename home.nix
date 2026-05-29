{ user, ... }:
{
  imports = [
    ./modules/stylix.nix
    ./modules/symlinks.nix
    ./modules/theme.nix
    ./modules/hyprpanel.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
}
