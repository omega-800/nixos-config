{ inputs, pkgs, ... }: 
let
  kaizen = inputs.kaizen.packages.${pkgs.system}.default;
in {
  imports = [ 
    ../dm
  ];
  
  # for faster build times
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  # copypasta
  environment = {
    systemPackages = with pkgs; [ kaizen ];
/*
    loginShellInit = ''
      # INFO: If removed, xwayland apps won't work, idk why.
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
    */
  };

  security.pam.services.ags = {};

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
}
