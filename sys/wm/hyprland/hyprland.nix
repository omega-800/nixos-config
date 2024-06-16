{ inputs, pkgs, ... }: 
let
  kaizen = inputs.kaizen.packages.${pkgs.system}.default;
in {
  imports = [ ../wayland/wayland.nix ];

  # copypasta
  environment = {
    systemPackages = with pkgs; [ kaizen kaivim linux-wifi-hotspot ];

    loginShellInit = /* bash */ ''
      # INFO: If removed, xwayland apps won't work, idk why.
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec Hyprland
      fi
    '';
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
