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
  users.users."${user}" = {
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
    extraSpecialArgs = { inherit inputs dotfiles; };
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
  services.openssh.enable = true;

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5min
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=2h";

  system.stateVersion = "24.11";

}
