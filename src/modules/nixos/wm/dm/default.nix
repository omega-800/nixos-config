{
  inputs,
  config,
  sys,
  lib,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.wm.dm;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
  cmd =
    if usr.wmType == "x11" then
      "startx"
    else
      # audible confusion
      # "lxqt-policykit-agent " +
      (if usr.wm == "hyprland" then "Hyprland" else usr.wm);
in
{
  options.m.wm.dm = {
    enable = mkOption {
      description = "enables dm";
      type = types.bool;
      default = usr.wm != "none";
    };
  };
  config = mkIf cfg.enable {
    # Enable Display Manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd ${cmd}";
          user = "greeter";
        };
      };
    };

    environment.systemPackages = with pkgs; [ greetd.tuigreet ];
    # failed attempt at solution below
    # boot.kernel.sysctl = { "kernel.printk" = "3 3 3 3"; };
    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };
  };
}
