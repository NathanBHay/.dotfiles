{ dotfiles, pkgs, ... }:
let
  gpu = "amdgpu";
in
{
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

  # Keyboard Configuration
  services.kanata = {
    enable = true;
    keyboards.internalKeyboard = {
      devices = [ "/dev/input/by-id/usb-ROYUAN_Akko_keyboard-event-kbd" ];
      configFile = "${dotfiles}/kanata.kbd";
    };
  };

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      IdleAction=suspend-then-hibernate
      IdleActionSec=5min
    '';
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  environment.systemPackages = with pkgs; [
    v4l-utils # Webcam
    streamdeck-ui # Streamdeck
  ];

  services.hardware.openrgb.enable = true;
}
