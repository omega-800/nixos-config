{ inputs, lib, config, home, pkgs, usr, ... }:
let dwm_stats = pkgs.writeShellScript "dwm_stats" ./dwm_stats.sh;
in {
  xresources.properties = { "*term" = usr.term; };
  home = {
    packages = with pkgs; [ inputs.omega-st ];
    file.".xinitrc".text = ''
      ${config.u.x11.initExtra}
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
}
