{ pkgs, user, ... }:
{
  programs.gamemode.enable = true;
  programs.steam.enable = true;

  home-manager.users."${user}".home.packages = with pkgs; [
    zulu25 # Java for 'The Craft'
    prismlauncher # The Craft
    # lutris
  ];
}
