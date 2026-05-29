{ pkgs, dotfiles, ... }:
let
  systemPackage =
    pkgs.runCommandLocal "system-package-placeholder"
      {
        meta.mainProgram = "system-package-placeholder";
      }
      ''
        mkdir -p "$out/bin"
        printf '%s\n' '#!/bin/sh' 'exit 127' > "$out/bin/system-package-placeholder"
        chmod +x "$out/bin/system-package-placeholder"
      '';
in
{
  gtk.gtk4.theme = null; # Suppress Warning

  programs = {
    bat = {
      enable = true;
      package = systemPackage;
    };

    btop = {
      enable = true;
      package = null;
    };

    kitty = {
      enable = true;
      package = null;
      extraConfig = builtins.readFile "${dotfiles}/kitty.conf";
    };

    mpv = {
      enable = true;
      package = systemPackage;
    };

    rofi = {
      enable = true;
      package = systemPackage;
    };

    vesktop = {
      enable = true;
      package = null;
    };

    yazi = {
      enable = true;
      package = null;
    };

    zathura = {
      enable = true;
      package = systemPackage;
    };
  };
}
