{
  pkgs,
  inputs,
  dotfiles,
  user,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.default ];

  # Nix Configuration
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  nix.extraOptions = "warn-dirty = false";

  # Bootloader
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = true;
    efiSupport = true;
    configurationLimit = 50;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Firmware
  hardware.enableAllFirmware = true;

  # Sound Settings
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };
  security.rtkit.enable = true;

  # User Account
  users.users.nathan = {
    isNormalUser = true;
    description = "Nathan Hay";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "audio"
      "lp"
      "scanner"
      "libvirtd"
    ];
    initialPassword = "1234";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGWmSH7SLD2WH4ii1eW4oDMsBycOhq02LQP2z2Wq8JqS nathan"
    ];
  };
  nix.settings.allowed-users = [ "@wheel" ];

  # Location Properties
  time.timeZone = "Europe/Berlin";

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

  # Core Packages
  environment.systemPackages = with pkgs; [
    git
    systemd
    nfs-utils
  ];

  fonts.packages = with pkgs.nerd-fonts; [
    fira-code
    fira-mono
  ];

  # Packages
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs dotfiles user; };
    users."${user}" = {
      home = {
        username = "${user}";
        homeDirectory = "/home/${user}";
        stateVersion = "24.11";
      };
      imports = [ ./modules/cli.nix ];
      programs.home-manager.enable = true;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Directory Environments
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  # Automount USB
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # SSH Daemon
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      AllowUsers = [ "nathan" ];
    };
  };

  programs.nix-ld.enable = true;

  system.stateVersion = "25.05";

}
