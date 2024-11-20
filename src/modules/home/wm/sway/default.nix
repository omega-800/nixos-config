{
  config,
  pkgs,
  usr,
  lib,
  sys,
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
in
{
  options.u.wm.sway.enable = mkOption {
    type = types.bool;
    default = usr.wm == "sway";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      checkConfig = true;
      package = nixGL pkgs.sway;
      xwayland = true;
      systemd.enable = true;
      extraConfig = import ./extraConfig.nix { inherit usr pkgs config; };
      config = {
        modifier = "Mod4";
        defaultWorkspace = "workspace number 1";
        workspaceAutoBackAndForth = true;
        workspaceLayout = "stacking";
        terminal = usr.term;
        startup = [ { command = usr.term; } ];
        assigns = (import ./assigns.nix).${sys.profile};
        # bars = import ./bars.nix;
        keybindings = mkOptionDefault (
          import ./keys.nix {
            inherit
              usr
              sys
              config
              pkgs
              lib
              ;
          }
        );
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
          outer = 5;
          inner = 10;
          smartBorders = "on";
          smartGaps = false;
        };
      };
      swaynag.enable = true;
    };
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "${pkgs.swaylock}/bin/swaylock -fF";
        }
        {
          event = "lock";
          command = "lock";
        }
      ];
    };
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
      };
    };
  };
}
