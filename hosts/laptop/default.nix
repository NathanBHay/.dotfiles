{ dotfiles, ... }: {
  imports = [ ./hardware-configuration.nix ];

  # Networking & Bluetooth
  networking.hostName = "NathanLaptop";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Keyboard Configuration
  services.kanata = {
    enable = true;
    keyboards.internalKeyboard = {
      devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      configFile = "${dotfiles}/kanata.kbd";
    };
  };

  # Power Management
  services.upower.enable = true;
}
