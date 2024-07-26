{ config, pkgs, usr, ... }:
let nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
in {
  wayland.windowManager.sway = {
    enable = true;
    package = (nixGL pkgs.sway);
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
}
