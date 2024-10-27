{ inputs, lib, config, home, pkgs, usr, ... }:
let
  cfg = config.u.wm.dwm;
  dwm_stats = pkgs.writeShellScript "dwm_stats" ./dwm_stats.sh;
  inherit (lib) mkOption mkIf types mkDefault;
in
{
  options.u.wm.dwm.enable = mkOption {
    type = types.bool;
    default = usr.wm == "dwm";
  };
  config = mkIf cfg.enable {
    xresources.properties = { "*term" = usr.term; };
    u = {
      user.st.enable = mkDefault true;
      x11.initExtra = ''
        ${dwm_stats} &
        #exec dbus-launch dwm
        exec dwm
      '';
    };

    #  services.dwm-status = {
    #    enable = true;
    #    order = [ "cpu_load" "network" "backlight" "audio" "battery" "time" ];
    #    extraConfig = {
    #      battery = {
    #        notifier_levels = [ 2 5 10 15 20 25 30 ];
    #      };
    #    };
    #  };
  };
}
