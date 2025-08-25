{
  usr,
  lib,
  net,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) flip mapAttrs' nameValuePair;
in
{
  services.borgbackup.jobs = {
    root = rec {
      # TODO:
      encryption.mode = "none";
      environment = {
        BORG_RSH = "ssh -i ${net.identityFile}";
        # BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
      };
      # FIXME: Failed to inhibit: Interactive authentication required.
      # inhibitsSleep = true;
      persistentTimer = true;
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      # FIXME:
      repo = "ssh://omega@little-fella.home.lan//store/backup/${net.hostname}/root";
      compression = "zstd,1";
      doInit = true;
      startAt = "daily";
      user = usr.username;
      paths = [
        "/srv"
        "/media"
        "/var"
      ];
      # exclude = builtins.concatMap (x: map (p: p + "/" + x) paths) common-excludes;
      prune = {
        keep = {
          within = "1d";
          daily = 7;
          weekly = 4;
          monthly = 6;
          yearly = -1;
        };
      };
    };
  };
  systemd.services =
    {
      "notify-problems@" = {
        enable = true;
        serviceConfig.User = usr.username;
        environment.SERVICE = "%i";
        script = ''
          export DBUS_SESSION_BUS_ADDRESS="''${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/''${UID}/bus}"
          ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
        '';
      };
    }
    // flip mapAttrs' config.services.borgbackup.jobs (
      name: _:
      nameValuePair "borgbackup-job-${name}" {
        unitConfig.OnFailure = "notify-problems@%i.service";
        preStart = lib.mkBefore ''
          until ${lib.getExe' pkgs.toybox "ping"} little-fella.home.lan -c1 -q >/dev/null; do :; done
        '';
      }
    );

  # optional, but this actually forces backup after boot in case laptop was powered off during scheduled event
  # for example, if you scheduled backups daily, your laptop should be powered on at 00:00
  systemd.timers = flip mapAttrs' config.services.borgbackup.jobs (
    name: _:
    nameValuePair "borgbackup-job-${name}" {
      timerConfig.Persistent = true;
    }
  );
}
