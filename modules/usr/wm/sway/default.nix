{ config, pkgs, usr, lib, sys, ... }:
let
  inherit (pkgs) nixGL;
  inherit (lib) mkOption mkIf types mkOptionDefault;
  cfg = config.u.wm.sway;
in
{
  options.u.wm.sway.enable = mkOption {
    type = types.bool;
    default = usr.wm == "sway";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pinentry-gnome3 polkit_gnome ];
    wayland.windowManager.sway = {
      enable = true;
      package = nixGL pkgs.sway;
      xwayland = true;
      systemd.enable = true;
      config = rec {
        modifier = "Mod4";
        # TODO: scawm
        keybindings = mkOptionDefault { };
        terminal = usr.term;
        startup = [{ command = usr.term; }];
        seat = { "*" = { hide_cursor = "when-typing enable"; }; };
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
      };
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
      settings = { show-failed-attempts = true; };
    };
  };
}
