{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Networking & Bluetooth
  networking.hostName = "NathanLaptop";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Power Management
  services.upower.enable = true;
}
