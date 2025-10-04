{
  lib,
  pkgs,
  globals,
  sys,
  config,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.wm.x11;
in
{
  imports = [ ./autorandr.nix ];
  options.u.wm.x11 = {
    enable = mkOption {
      type = types.bool;
      default = usr.wmType == "x11";
    };
    initExtra = mkOption {
      type = types.lines;
      default = "";
    };
  };
  config = mkIf cfg.enable {
    home.keyboard = {
      layout = sys.kbLayout;
    };
    services.unclutter = {
      enable = true;
      threshold = 5;
      timeout = 2;
      extraOptions = [
        "ignore-scrolling"
        "fork"
        "start-hidden"
      ];
    };
    # FIXME: put startup stuff into generic config to use for all wm's (nm-applet etc.)
    xdg.configFile."X11/xinitrc".text = ''
      sxhkd &
      xrandr
      xrdb ${globals.envVars.XRESOURCES}
      #redshift -O3500
      xset -b
      xset r rate 300 50
      udiskie & # i *think* this isn't needed as it's running as a systemd service too?
      ibus-daemon -rxRd
      # picom & # is running as systemd service now
      systemctl --user import-environment DISPLAY
      dunst &
      nm-applet &
      # exec --no-startup-id dunst
      ${pkgs.notify_bat} &
      ${if sys.genericLinux then "source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh" else ""}
      ${cfg.initExtra}
    '';
    xresources.path = globals.envVars.XRESOURCES;
  };
}
