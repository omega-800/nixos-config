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
  cfg = config.m.wm.dm.tuigreet;
  inherit (lib)
    mkEnableOption
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
  options.m.wm.dm.tuigreet.enable = mkEnableOption "tuigreet";

  config = mkIf cfg.enable {

    users.users.${usr.username}.extraGroups = [ "seat" ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd ${cmd}";
          user = "greeter";
        };
      };
    };

    # failed attempt at solution below
    # boot.kernel.sysctl = { "kernel.printk" = "3 3 3 3"; };
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
