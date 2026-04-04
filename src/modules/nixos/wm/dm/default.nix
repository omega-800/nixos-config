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
