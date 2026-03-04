{ ... }:
{
  programs.hyprpanel.settings = {
    bar = {
      bluetooth.label = false;
      customModules.weather.unit = "metric";
      launcher.icon = "";
      layouts = {
        "0" = {
          extends = "*";
          middle = [ ];
          right = [
            "systray"
            "volume"
            "network"
            "bluetooth"
            "battery"
            "clock"
            "notifications"
          ];
        };
        "*" = {
          left = [
            "dashboard"
            "workspaces"
            "windowtitle"
          ];
          middle = [
            "media"
          ];
          right = [
            "volume"
            "clock"
            "notifications"
          ];
        };
      };
      network.label = false;
      volume.label = false;
      workspaces = {
        monitorSpecific = false;
        showApplicationIcons = false;
        show_icons = false;
        show_numbered = false;
        showWsIcons = false;
        spacing = 0.7;
        workspaceMask = false;
        workspaces = 7;
      };
    };
    menus = {
      clock = {
        weather = {
          interval = 1000000;
          key = "/home/nathan/.config/.weather.json"; # TODO: Make secret
          location = "Melbourne";
          unit = "metric";
        };
      };
      dashboard = {
        controls.enable = false;
        directories.left.directory3 = {
          command = "bash -c \"xdg-open $HOME/MEGA/\"";
          label = "󰚝 MEGA";
        };
        powermenu.avatar.image = "/home/nathan/Pictures/.avatar.jpg";
        shortcuts.enabled = false;
      };
      power.lowBatteryNotification = true;
      transition = "crossfade";
    };
    notifications.ignore = [ "spotify" ];
    scalingPriority = "gdk";
    theme = {
      bar = {
        border.location = "none";
        buttons = {
          background_opacity = 0;
          bluetooth.spacing = "0.5em";
          enableBorders = false;
          padding_x = "0.5rem";
          spacing = "0.1em";
          systray.enableBorder = false;
        };
        floating = false;
        location = "bottom";
        menus = {
          menu = {
            battery.scaling = 70;
            bluetooth.scaling = 70;
            clock.scaling = 70;
            dashboard = {
              confirmation_scaling = 70;
              scaling = 60;
            };
            media.scaling = 70;
            network.scaling = 70;
            notifications.scaling = 70;
            power.scaling = 70;
            volume.scaling = 70;
          };
          opacity = 90;
          popover.scaling = 70;
        };
        opacity = 99;
        outer_spacing = "0.8em";
        scaling = 70;
        transparent = false;
      };
      notification = {
        opacity = 90;
        scaling = 70;
      };
      osd.scaling = 70;
      tooltip.scaling = 70;
    };
  };
}
