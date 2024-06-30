{ config, pkgs, inputs, dotfiles, ... }:
{
  imports = [
    ./hosts/laptop/hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    configurationLimit = 50;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking & Bluetooth
  networking = {
    hostName = "NathanLaptop";
    networkmanager.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.rtkit.enable = true;

  # Sound Settings
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # User Account
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan Hay";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" ];
  };
  nix.settings.allowed-users = [ "@wheel" ];

  # Location Properties
  time.timeZone = "Australia/Melbourne";

  i18n.defaultLocale = "en_AU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Configure xserver
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "au";
    variant = "";
  };

  # Display Manager
  services.displayManager.sddm.enable = true;

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

  # Packages
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs dotfiles;};
    users.nathan = {
      home = {
        username = "nathan";
        homeDirectory = "/home/nathan";
        stateVersion = "24.05";
      };
      imports = [ ./modules ];
      programs.home-manager.enable = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # SSH Daemon
  services.openssh.enable = true;

  system.stateVersion = "24.05";

}
