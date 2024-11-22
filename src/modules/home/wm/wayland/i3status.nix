{
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.u.wm.i3status;
  inherit (lib) mkIf mkOption types;
in
{
  options.u.wm.i3status.enable = mkOption {
    description = "enables i3status";
    type = types.bool;
    default = config.u.wm.sway.enable;
  };
  config = mkIf cfg.enable {
    programs.i3status = {
      enable = true;
      enableDefault = false;
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
            format_up = " [E] %ip %speed ";
          };
        };
        # wifi 
        "wireless _first_" = {
          position = 2;
          settings = {
            format_down = " [W] X ";
            format_up = " [W] %ip %essid%quality ";
          };
        };
        # vpn
        "path_exists VPN" = {
          position = 3;
          settings = {
            # TODO:
            path = "/proc/sys/net/ipv4/conf/tun0";
            format = " [V] X ";
          };
        };
        # cpu 
        "cpu_usage" = {
          position = 4;
          settings = {
            format = " [C] %usage ";
            degraded_threshold = 30;
            max_threshold = 70;
          };
        };
        # mem 
        "memory" = {
          position = 5;
          settings = {
            format = " [M] %used/%total ";
            threshold_degraded = "40%";
            threshold_critical = "10%";
          };
        };
        # disk_root 
        "disk /" = {
          position = 6;
          settings = {
            format = " [R] %used/%total ";
            threshold_type = "percentage_free";
            low_threshold = 20;
          };
        };
        # disk_home 
        "disk ${usr.homeDir}" = {
          position = 7;
          settings = {
            format = " [H] %used/%total ";
            threshold_type = "percentage_free";
            low_threshold = 20;
          };
        };
        # TODO:
        # backlight = {
        #   position = 8;
        #   settings = {
        #     format = " [S] ";
        #   };
        # };

        # audio 
        "volume master" = {
          position = 9;
          settings = {
            format = " [A] %volume ";
            format_muted = " [M] %volume ";
            device = "pulse";
          };
        };
        # battery 
        "battery all" = {
          position = 10;
          settings = {
            format = " [B] %status%percentage  ";
            format_down = " [B] X ";
            status_chr = "+";
            status_bat = "-";
            status_unk = "?";
            status_full = "!";
            status_idle = "=";
            threshold_type = "percentage";
            low_threshold = 20;
          };
        };
        # time 
        "tztime local" = {
          position = 11;
          settings = {
            format = " %H:%M ";
          };
        };
        # date
        "time" = {
          position = 12;
          settings = {
            format = " %d-%m-%y ";
          };
        };
      };
    };
  };
}
