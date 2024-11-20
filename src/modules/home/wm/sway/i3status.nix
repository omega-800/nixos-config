{
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.u.wm.sway;
  inherit (lib) mkIf;
in
{
  config = mkIf cfg.enable {
    programs.i3status = {
      enable = true;
      enableDefault = true;
      general = with config.lib.stylix.colors; {
        colors = true;
        color_good = "#${base0B}";
        color_degraded = "#${base0E}";
        color_bad = "#${base0F}";
        interval = 10;
        separator = "|";
        output_format = "i3bar";
      };
      modules = {
        # eth 
        "ethernet _first_" = {
          position = 1;
          settings = {
            format_down = " [E] X ";
            format_up = " [E] %ip (%speed) ";
          };
        };
        # wifi 
        "wireless _first_" = {
          position = 2;
          settings = {
            format_down = " [W] X ";
            format_up = " [W] (%quality at %essid) %ip ";
          };
        };
        # TODO:
        # vpn = { };

        # ipv6
        "ipv6" = {
          position = 3;
        };
        # cpu 
        "load" = {
          position = 4;
          settings = {
            format = " [C] %1min ";
          };
        };
        # mem 
        "memory" = {
          position = 5;
          settings = {
            format = "%used | %available";
            format_degraded = "MEMORY < %available";
            threshold_degraded = "1G";
          };
        };
        # disk_root 
        "disk /" = {
          position = 6;
          settings = {
            format = "%avail";
          };
        };
        # disk_home 
        "disk ${usr.homeDir}" = {
          position = 7;
          settings = {
            format = "%avail";
          };
        };
        # TODO:
        # backlight = { };

        # audio 
        "volume master" = {
          position = 9;
          settings = {
            format = "%volume";
            format_muted = "M (%volume)";
            device = "pulse:1";
          };
        };
        # battery 
        "battery all" = {
          position = 10;
          settings = {
            format = "%status %percentage %remaining";
          };
        };
        # time date 
        "tztime local" = {
          position = 11;
          settings = {
            format = "%H:%M %d-%m-%y";
          };
        };
      };
    };
  };
}

/*
  battery all {
    format = "%status %percentage %remaining"
  }

  disk / {
    format = "%avail"
  }

  ethernet _first_ {
    format_down = "E: down"
    format_up = "E: %ip (%speed)"
  }

  ipv6 {

  }

  load {
    format = "%1min"
  }

  memory {
    format = "%used | %available"
    format_degraded = "MEMORY < %available"
    threshold_degraded = "1G"
  }

  tztime local {
    format = "%Y-%m-%d %H:%M:%S"
  }

  wireless _first_ {
    format_down = "W: down"
    format_up = "W: (%quality at %essid) %ip"
  }
*/
