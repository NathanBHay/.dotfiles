{ pkgs, dotfiles, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  # Networking & Bluetooth
  networking.hostName = "NathanLaptop";

  # Keyboard Configuration
  services.kanata = {
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
  services.upower.enable = true;

  # Printing
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser ];
  };
}
