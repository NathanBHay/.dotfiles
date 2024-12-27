{ ... }:
{
  # imports = [ ./hardware-configuration.nix ];

  # Networking & Bluetooth
  networking.hostName = "NathanPi";

  nixpkgs.crossSystem = {
    system = "aarch64-linux";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
