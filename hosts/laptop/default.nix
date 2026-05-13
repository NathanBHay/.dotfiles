{ pkgs, dotfiles, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Networking & Bluetooth
  networking.hostName = "NathanLaptop";

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  boot.kernelParams = [ "usbcore.autosuspend=180" ];

  services = {
    # Keyboard Configuration
    kanata = {
      enable = true;
      keyboards.internalKeyboard = {
        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
          "/dev/input/by-id/usb-Usb_KeyBoard_Usb_KeyBoard-event-kbd"
        ];
        configFile = "${dotfiles}/kanata.kbd";
      };
    };

    # Power Management
    upower.enable = true;

    tlp.enable = true;

    # Printing
    printing = {
      enable = false;
      drivers = with pkgs; [ brlaser ];
    };

    # VPN
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };
  };

  hardware.logitech.wireless.enable = true;

  environment.systemPackages = with pkgs; [
    solaar
  ];
}
