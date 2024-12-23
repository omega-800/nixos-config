{
  inputs,
  config,
  lib,
  pkgs,
  sys,
  usr,
  ...
}:
let
  lock_cmd = "pidof hyprlock || hyprlock";
  suspend_cmd = "pidof steam || systemctl suspend || loginctl suspend"; # fuck nvidia
  inherit (lib)
    mkOption
    mkIf
    types
    mkDefault
    ;
  cfg = config.u.wm.hyprland;
in
{
  options.u.wm.hyprland.enable = mkOption {
    type = types.bool;
    default = usr.wm == "hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        # inputs.hycov.packages.${pkgs.system}.hycov
      ];
      xwayland.enable = true;
      systemd.enable = true;
      extraConfig = ''
        ${builtins.readFile ./config/modules/general.conf}
        ${builtins.readFile ./config/modules/io.conf}
        ${builtins.readFile ./config/modules/keys.conf}
        ${builtins.readFile ./config/modules/style.conf}
        ${builtins.readFile ./config/modules/rules.conf}
      '';
    };

    home.packages = with pkgs; [
      killall
      pinentry-gnome3
      polkit_gnome
      wlr-randr
      wtype
      ydotool
      wl-clipboard
      hyprland-protocols
      hyprpicker
      fnott
      fuzzel
      keepmenu
      wev
      grim
      slurp
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      xdg-utils
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      wlsunset
      pamixer
      tesseract4
    ];
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = lock_cmd;
          before_sleep_cmd = lock_cmd;
        };
        listener = [
          {
            timeout = 180; # 3mins
            on-timeout = lock_cmd;
          }
          {
            timeout = 240; # 4mins
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 540; # 9mins
            on-timeout = suspend_cmd;
          }
        ];
      };
    };
    programs = {
      hyprlock = {
        enable = true;
        extraConfig = builtins.replaceStrings [ "~/.config/hypr/hyplock/status.sh" ] [
          "${lib.writeShellScript "hyprlockstatus" builtins.readFile ./config/hyprlock/status.sh}"
        ] (builtins.readFile ./config/hyprlock.conf);
      };

      waybar = {
        enable = true;
        settings = {
          mainBar = {
            layer = "top";
            position = "top";
            height = 35;
            margin = "7 7 3 7";
            spacing = 2;

            modules-left = [
              "custom/os"
              "custom/hyprprofile"
              "battery"
              "backlight"
              "keyboard-state"
              "pulseaudio"
              "cpu"
              "memory"
            ];
            modules-center = [ "hyprland/workspaces" ];
            modules-right = [
              "idle_inhibitor"
              "tray"
              "clock"
            ];

            "custom/os" = {
              "format" = " {} ";
              "exec" = ''echo "" '';
              "interval" = "once";
            };
            "custom/hyprprofile" = {
              "format" = "   {}";
              "exec" = "cat ~/.hyprprofile";
              "interval" = 3;
              "on-click" = "hyprprofile-dmenu";
            };
            "keyboard-state" = {
              "numlock" = true;
              "format" = " {icon} ";
              "format-icons" = {
                "locked" = "󰎠";
                "unlocked" = "󱧓";
              };
            };
            "hyprland/workspaces" = {
              "format" = "{icon}";
              "format-icons" = {
                "1" = "󱚌";
                "2" = "󰖟";
                "3" = "";
                "4" = "󰎄";
                "5" = "󰋩";
                "6" = "";
                "7" = "󰄖";
                "8" = "󰑴";
                "9" = "󱎓";
                "scratch_term" = "_";
                "scratch_ranger" = "_󰴉";
                "scratch_musikcube" = "_";
                "scratch_btm" = "_";
                "scratch_pavucontrol" = "_󰍰";
              };
              "on-click" = "activate";
              "on-scroll-up" = "hyprctl dispatch workspace e+1";
              "on-scroll-down" = "hyprctl dispatch workspace e-1";
              #"all-outputs" = true;
              #"active-only" = true;
              "ignore-workspaces" = [
                "scratch"
                "-"
              ];
              #"show-special" = false;
              #"persistent-workspaces" = {
              #    # this block doesn't seem to work for whatever reason
              #    "eDP-1" = [1 2 3 4 5 6 7 8 9];
              #    "DP-1" = [1 2 3 4 5 6 7 8 9];
              #    "HDMI-A-1" = [1 2 3 4 5 6 7 8 9];
              #    "1" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "2" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "3" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "4" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "5" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "6" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "7" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "8" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #    "9" = ["eDP-1" "DP-1" "HDMI-A-1"];
              #};
            };

            "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                activated = "󰅶";
                deactivated = "󰾪";
              };
            };
            tray = {
              #"icon-size" = 21;
              "spacing" = 10;
            };
            clock = {
              "interval" = 1;
              "format" = "{:%a %Y-%m-%d %I:%M:%S %p}";
              "timezone" = sys.timezone;
              "tooltip-format" = ''
                <big>{:%Y %B}</big>
                <tt><small>{calendar}</small></tt>'';
            };
            cpu = {
              "format" = "{usage}% ";
            };
            memory = {
              "format" = "{}% ";
            };
            backlight = {
              "format" = "{percent}% {icon}";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
                ""
              ];
            };
            battery = {
              "states" = {
                "good" = 95;
                "warning" = 30;
                "critical" = 15;
              };
              "format" = "{capacity}% {icon}";
              "format-charging" = "{capacity}% ";
              "format-plugged" = "{capacity}% ";
              #"format-good" = ""; # An empty format will hide the module
              #"format-full" = "";
              "format-icons" = [
                ""
                ""
                ""
                ""
                ""
              ];
            };
            pulseaudio = {
              "scroll-step" = 1;
              "format" = "{volume}% {icon}  {format_source}";
              "format-bluetooth" = "{volume}% {icon}  {format_source}";
              "format-bluetooth-muted" = "󰸈 {icon}  {format_source}";
              "format-muted" = "󰸈 {format_source}";
              "format-source" = "{volume}% ";
              "format-source-muted" = " ";
              "format-icons" = {
                "headphone" = "";
                "hands-free" = "";
                "headset" = "";
                "phone" = "";
                "portable" = "";
                "car" = "";
                "default" = [
                  ""
                  ""
                  ""
                ];
              };
              "on-click" = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
            };
          };
        };
      };
    };
  };
}
