{ inputs, config, sys, lib, pkgs, usr, ... }:
let
  cfg = config.m.wm.x11;
  inherit (lib) mkOption types mkIf mkMerge;
  slock = (pkgs.callPackage ./slock.nix { inherit (inputs) omega-slock; });
in {
  options.m.wm.x11 = {
    enable = mkOption {
      description = "enables x11";
      type = types.bool;
      default = (builtins.elem usr.wm [ "qtile" "xmonad" "dwm" ]) && usr.wmType
        == "x11";
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
      displayManager = { startx.enable = true; };
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
