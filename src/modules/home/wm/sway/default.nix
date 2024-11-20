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
    mkOptionDefault
    ;
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
  imports = [ ./i3status.nix ];
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
      config = {
        inherit
          assigns
          keybindings
          modes
          bars
          ;
        modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        workspaceAutoBackAndForth = true;
        # workspaceLayout = "stacking";
        terminal = usr.term;
        startup = [
          { command = usr.term; }
          { command = "exec sway-audio-idle-inhibit"; }
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
        focus.followMouse = false;
      };
      swaynag.enable = true;
    };
  };
}
