{ pkgs, lib, ... }: {
  # Nix Configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = "warn-dirty = false";

  # Bootloader
  boot.loader.grub = {
    enable = lib.mkDefault true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    configurationLimit = 50;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Firmware
  hardware.enableAllFirmware = true;

  # User Account
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan Hay";
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" ];
    initialPassword = "1234";
  };
  nix.settings.allowed-users = [ "@wheel" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Core Packages
  environment.systemPackages = with pkgs; [ git systemd ];

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # SSH Daemon
  services.openssh.enable = true;

  system.stateVersion = "24.05";

}
