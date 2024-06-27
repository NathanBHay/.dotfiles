{ config, pkgs, ... }:

{
  home = {
    username = "nathan";
    homeDirectory = "/home/nathan";
    stateVersion = "24.05";
    packages = with pkgs; [
      zsh
    ];
    file = {
      ".zshrc".source = ./.dotfiles/.zshrc;
    };
    sessionVariables = {};
  };
  programs.zsh.enable = true;
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
