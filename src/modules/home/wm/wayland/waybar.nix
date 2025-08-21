{
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.u.wm.waybar;
  inherit (lib) mkIf mkEnableOption types;
in
{
  options.u.wm.waybar.enable = mkEnableOption "waybar";
  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      # style = '''';
      settings = {
        main = {
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
            "HDMI-A-1"
          ];
          modules-left = [
            "sway/workspaces"
            "sway/mode"
          ];
          modules-center = [
            "sway/window"
            "custom/hello-from-waybar"
          ];
          modules-right = [
            "mpd"
            "temperature"
          ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
          "sway/window" = {
            "max-length" = 50;
          };
          "battery" = {
            "format" = "{capacity}% {icon}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          "clock" = {
            "format-alt" = "{:%a, %d. %b  %H:%M}";
          };
        };
      };

      # enableDefault = true;
      # general = with config.lib.stylix.colors; {
      #   color_good = "#${base0B}";
      #   color_degraded = "#${base0E}";
      #   color_bad = "#${base0F}";
      #   separator = "|";
      # };
      # modules = {
      #   # eth 
      #   "ethernet _first_" = {
      #     position = 1;
      #     settings = {
      #       format_down = " [E] X ";
      #       format_up = " [E] %ip (%speed) ";
      #     };
      #   };
      #   # wifi 
      #   "wireless _first_" = {
      #     position = 2;
      #     settings = {
      #       format_down = " [W] X ";
      #       format_up = " [W] %ip %essid %quality ";
      #     };
      #   };
      #   # vpn
      #   "path_exists VPN" = {
      #     position = 3;
      #     settings = {
      #       path = "/proc/sys/net/ipv4/conf/tun0";
      #       format = " [V] ";
      #     };
      #   };
      #   # cpu 
      #   "load" = {
      #     position = 4;
      #     settings = {
      #       format = " [C] %1min ";
      #     };
      #   };
      #   # mem 
      #   "memory" = {
      #     position = 5;
      #     settings = {
      #       format = " [M] %used / %available ";
      #       format_degraded = "MEMORY < %available";
      #       threshold_degraded = "1G";
      #     };
      #   };
      #   # disk_root 
      #   "disk /" = {
      #     position = 6;
      #     settings = {
      #       format = " [R] %free / %avail ";
      #     };
      #   };
      #   # disk_home 
      #   "disk ${usr.homeDir}" = {
      #     position = 7;
      #     settings = {
      #       format = " [H] %avail ";
      #     };
      #   };
      #   # TODO:
      #   # backlight = {
      #   #   position = 8;
      #   #   settings = {
      #   #     format = " [S] ";
      #   #   };
      #   # };
      #
      #   # audio 
      #   "volume master" = {
      #     position = 9;
      #     settings = {
      #       format = " [A] %volume ";
      #       format_muted = " [M] %volume ";
      #       device = "pulse:1";
      #     };
      #   };
      #   # battery 
      #   "battery all" = {
      #     position = 10;
      #     settings = {
      #       format = " [B] %status %percentage %remaining ";
      #     };
      #   };
      #   # time date 
      #   "tztime local" = {
      #     position = 11;
      #     settings = {
      #       format = " %H:%M %d-%m-%y ";
      #     };
      #   };
      # };
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
