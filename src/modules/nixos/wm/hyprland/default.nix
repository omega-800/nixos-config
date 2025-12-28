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
  cfg = config.m.wm.hyprland;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
in
{
  options.m.wm.hyprland = {
    enable = mkOption {
      description = "enables hyprland";
      type = types.bool;
      default = usr.wm == "hyprland";
    };
  };
  config = mkIf cfg.enable {
    # for faster build times
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    # copypasta
    environment = {
      /*
        loginShellInit = ''
        # INFO: If removed, xwayland apps won't work, idk why.
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec Hyprland
        fi
          '';
      */
    };

    security.pam.services.ags = { };

    programs = {
      #droidcam.enable = true;
      hyprland = {
        enable = true;
        #package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland = {
          enable = true;
        };
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
  };
}
