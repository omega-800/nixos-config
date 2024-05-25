{ inputs, pkgs, ... }:
with lib;
let cfg = config.u.hyprland;
in {
  options.u.hyprland = {
    enable = mkEnableOption "enables hyprland";
  };
 
  config = mkIf cfg.enable {
    imports = [ ../wayland/wayland.nix ];

    # Security
    security = {
      pam.services.swaylock = {
        text = ''
          auth include login
        '';
      };
      # pam.services.gtklock = {};
      pam.services.login.enableGnomeKeyring = true;
    };

    services.gnome.gnome-keyring.enable = true;

    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        xwayland = {
          enable = true;
        };
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };
    };
  };
}
