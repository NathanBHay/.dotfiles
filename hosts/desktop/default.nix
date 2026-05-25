{ pkgs, ... }:
let
  gpu = "amdgpu";
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/gaming.nix
  ];

  # Networking & Bluetooth
  networking.hostName = "NathanDesktop";

  # GPU & Graphics
  boot.initrd.kernelModules = [ gpu ];
  services.xserver.videoDrivers = [ gpu ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Keyboard Configuration
  services = {
    logind.settings.Login = {
      lidSwitch = "suspend-then-hibernate";
      extraConfig = ''
        HandlePowerKey=suspend-then-hibernate
        IdleAction=suspend-then-hibernate
        IdleActionSec=5min
      '';
    };

    hardware.openrgb.enable = true;
  };

  environment.systemPackages = with pkgs; [
    v4l-utils # Webcam
    streamdeck-ui # Streamdeck
  ];
}
