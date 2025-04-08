{
  config,
  pkgs,
  usr,
  lib,
  sys,
  globals,
  ...
}:
let
  inherit (pkgs) nixGL;
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  inherit (builtins) readFile;
  cfg = config.u.wm.sway;
  assigns = (import ./assigns.nix).${sys.profile};
  bars = import ./bars.nix {
    inherit
      config
      pkgs
      globals
      usr
      ;
  };
  keybindings = import ./keys.nix {
    inherit
      usr
      sys
      config
      pkgs
      lib
      ;
  };
  modes = import ./modes.nix {
    inherit
      usr
      pkgs
      config
      ;
  };
in
{
  options.u.wm.sway.enable = mkOption {
    type = types.bool;
    default = usr.wm == "sway";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ sway-audio-idle-inhibit ];
    wayland.windowManager.sway = {
      enable = true;
      checkConfig = true;
      package = nixGL pkgs.sway;
      xwayland = true;
      systemd.enable = true;
      # https://gitlab.com/that1communist/dotfiles/-/blob/master/.config/sway/modules/win-rules
      extraConfig =
        (readFile ./win-rules)
        + (
          if sys.profile == "work" then
            ''
              output eDP-1 pos 0 0 res 1920x1080
              output DP-8 pos 1920 0 res 1920x1080
              output DP-9 pos 3840 0 res 1920x1080
              output DP-6 pos 1920 0 res 1920x1080
              output DP-7 pos 3840 0 res 1920x1080
              workspace 1 output eDP1
              workspace 2 output eDP1
              workspace 3 output eDP1
              workspace 4 output DP-8
              workspace 5 output DP-8
              workspace 6 output DP-8
              workspace 7 output DP-8
              workspace 8 output DP-9
              workspace 9 output DP-9
              workspace 10 output DP-9
              workspace 4 output DP-6
              workspace 5 output DP-6
              workspace 6 output DP-6
              workspace 7 output DP-6
              workspace 8 output DP-7
              workspace 9 output DP-7
              workspace 10 output DP-7
            ''
          else
            ""
        );
      config = {
        inherit
          assigns
          keybindings
          modes
          bars
          ;
        # handled by scawm
        # modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        workspaceAutoBackAndForth = true;
        # workspaceLayout = "stacking";
        terminal = usr.term;
        startup = [
          { command = "${usr.term} -e tmux a"; }
          { command = "exec nohup sway-audio-idle-inhibit &"; }
          { command = "exec ${pkgs.writeShellScript "notify-bat" ./notify-bat.sh}"; }
          {
            command = "exec sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
          }
        ];
        seat = {
          "*" = {
            hide_cursor = "when-typing enable";
          };
        };
        input = {
          "*" = {
            xkb_layout = "ch";
            xkb_variant = "de";
          };
          "type:keyboard" = {
            repeat_delay = "300";
            repeat_rate = "50";
          };
          "type:touchpad" = {
            tap = "enabled";
            natural_scroll = "disabled";
            accel_profile = "adaptive";
          };
        };
        gaps = {
          # bottom = 5;
          # top = 5;
          # left = 5;
          # right = 5;
          # horizontal = 5;
          # vertical = 5;
          outer = 2;
          inner = 5;
          smartBorders = "on";
          smartGaps = false;
        };
        floating = {
          border = 2;
          criteria = [
            # am i stupid or should this not enforce floating behavior?
            { class = "Pavucontrol"; }
            { class = "Gpick"; }
          ];
        };
        focus.followMouse = false;
      };
      swaynag.enable = true;
    };
  };
}
