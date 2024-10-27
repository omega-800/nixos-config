{ config
, pkgs
, usr
, ...
}:
let
  inherit (pkgs) nixGL;
in
# nixGL = import ../../nixGL/nixGL.nix {inherit config pkgs;};
{
  home.packages = with pkgs; [
    pinentry-gnome3
    polkit_gnome
  ];
  wayland.windowManager.sway = {
    enable = true;
    package = (nixGL pkgs.sway);
    xwayland = true;
    systemd.enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = usr.term;
      startup = [{ command = usr.term; }];
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
    settings = {
      show-failed-attempts = true;
    };
  };
}
