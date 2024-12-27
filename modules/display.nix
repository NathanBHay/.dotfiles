{ pkgs, user, ... }:
{

  # Home Manager Modules
  home-manager.users."${user}".imports = [
    ./applications.nix
    ./theme.nix
  ];

  # Configure xserver
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Display Manager & Hyprland
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "${user}";
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "hyprland";
    XDG_SESSION_DESKTOP = "hyprland";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    GDK_BACKEND = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [ hyprpanel ];

  # Portal
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    config.common.default = "*";
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Bootloader Theme
  catppuccin.grub.enable = true;
}
