{ pkgs, ... }:
let gpu = "amdgpu";
in {
  imports = [ ./hardware-configuration.nix ];

  # Networking & Bluetooth
  networking.hostName = "NathanDesktop";

  # GPU & Graphics
  boot.initrd.kernelModules = [ gpu ];
  services.xserver.videoDrivers = [ gpu ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.hardware.openrgb.enable = true;
}
