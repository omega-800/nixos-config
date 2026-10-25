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
  cfg = config.m.wm.dm.lemurs;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
  mkEnableOption
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
  # breaks bluetooth??
  # i was{ted HOURS if not *DAYS*
  options.m.wm.dm.lemurs.enable = mkEnableOption "tuigreet";
  # and it was because of THE DM????
  # WHAT THE FUCK
  # https://github.com/NixOS/nixpkgs/issues/504925
  config = mkIf cfg.enable {
    users.users.${usr.username}.extraGroups = [ "seat" ];

    environment.etc."lemurs/wayland/${cmd}".text = ''
      #!/bin/sh

      exec ${cmd}
    '';

    services.displayManager.lemurs = {
      enable = true;
      # settings = { };
    };
  };
}
