{ config, sys, lib, ... }:
let
  cfg = config.m.sec.pam;
  inherit (lib) mkOption types mkIf mkMerge mkDefault mkBefore;
in {
  options.m.sec.pam = {
    enable = mkOption {
      description = "enables pam";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened;
    };
  };
  config = mkIf cfg.enable {
    #TODO: research and harden
    security.pam = {
      # or just copy-paste :')
      loginLimits = [{
        domain = "*";
        item = "core";
        type = "hard";
        value = "0";
      }];
      services = {
        # Increase hashing rounds for /etc/shadow; this doesn't automatically
        # rehash your passwords, you'll need to set passwords for your accounts
        # again for this to work.
        passwd.text = ''
          password required pam_unix.so sha512 shadow nullok rounds=65536
        '';
        # Enable PAM support for securetty, to prevent root login.
        # https://unix.stackexchange.com/questions/670116/debian-bullseye-disable-console-tty-login-for-root
        login.text = mkDefault (mkBefore ''
          # Enable securetty support.
          auth       requisite  pam_nologin.so
          auth       requisite  pam_securetty.so
        '');

        su.requireWheel = true;
        su-l.requireWheel = true;
        system-login.failDelay.delay = "4000000";
      };
    };
  };
}
