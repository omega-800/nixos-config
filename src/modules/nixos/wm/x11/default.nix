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
  cfg = config.m.wm.x11;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
  slock = pkgs.slock.override {
    conf = ''
      static const char *user  = "${usr.username}";
      static const char *group = "${config.users.users.${usr.username}.group}";

      static const char *colorname[NUMCOLS] = {
      	[INIT] =   "black",     /* after initialization */
      	[INPUT] =  "#005577",   /* during input */
      	[INPUT_ALT] = "#227799", /* during input, second color */
      	[FAILED] = "#CC3333",   /* wrong password */
      	[CAPS] = "red",         /* CapsLock on */
      };

      /* treat a cleared input like a wrong password (color) */
      static const int failonclear = 1;

      /* default message */
      static const char * message = "Suckless: Software that sucks less.";

      /* text color */
      static const char * text_color = "#ffffff";

      /* text size (must be a valid size) */
      static const char * font_name = "6x10";

      /*
       * Xresources preferences to load at startup
       */
      ResourcePref resources[] = {
      		{ "color0",       STRING,  &colorname[INIT] },
      		{ "color4",       STRING,  &colorname[INPUT] },
      		{ "color5",       STRING,  &colorname[INPUT_ALT] },
      		{ "color1",       STRING,  &colorname[FAILED] },
      		{ "color3",       STRING,  &colorname[CAPS] },
      		{ "color9",       STRING,  &text_color },
      };
    '';
    patches = [ ./slock.diff ];
  };
in
{
  # TODO: udev rule for hdmi
  # https://wiki.archlinux.org/title/Udev
  options.m.wm.x11 = {
    enable = mkOption {
      description = "enables x11";
      type = types.bool;
      default = usr.wmType == "x11";
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      xkb = {
        layout = "ch";
        variant = "de";
      };
      excludePackages = [ pkgs.xterm ];
      displayManager.startx.enable = true;
      xautolock = {
        enable = true;
        enableNotifier = true;
        notifier = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds'";
        notify = 10;
        locker = "${slock}/bin/slock -m 'lockidy lockedoodled'";
        time = 10;
        nowlocker = "${slock}/bin/slock -m 'lockidy lock locked'";
        killtime = 20;
        killer = "/run/current-system/systemd/bin/systemctl suspend";
        extraOptions = [ "-secure" ];
      };
    };
    programs.slock = {
      enable = true;
      package = slock;
    };
  };
}
