{ pkgs, ... }: 
let 
  slock = (pkgs.callPackage ./slock.nix {});
in {
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ch";
      variant = "de";
    };
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      startx.enable = true;
    };
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
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      middleEmulation = true;
      disableWhileTyping = true;
    };
  };
  programs = {
    slock = {
      enable = true;
      package = slock;
    };
  };
               }
