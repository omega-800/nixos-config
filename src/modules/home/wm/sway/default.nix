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
  bars = import ./bars.nix { inherit config pkgs globals; };
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
      extraConfig = readFile ./win-rules;
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
