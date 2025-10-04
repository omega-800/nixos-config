{
  usr,
  net,
  globals,
  lib,
  pkgs,
  ...
}:
let
  common-excludes = [
    # Largest cache dirs
    ".cache"
    "*/cache2" # firefox
    "*/Cache"
    ".config"
    # ".config/Slack/logs"
    # ".config/Code/CachedData"
    ".container-diff"
    ".npm/_cacache"
    "*/node_modules"
    "*/bower_components"
    "*/_build"
    "*/.tox"
    "*/venv"
    "*/.venv"
  ];
  inherit (lib) concatMapStrings;
in
{
  systemd.user = {
    timers.borg-backup-home = {
      Unit.Description = "Borg user backup timer";
      Timer = {
        WakeSystem = false;
        OnCalendar = "*-*-* 0/1:00:00";
        RandomizedDelaySec = "10min";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
    services.borg-backup-home = {
      Unit.Description = "Borg user backup";
      Service =
        let
          # FIXME:
          repo = "ssh://omega@little-fella.home.lan//store/backup/${net.hostname}/home";
        in
        {
          Type = "simple";
          Nice = 19;
          IOSchedulingClass = 2;
          IOSchedulingPriority = 7;
          ExecStartPre = "${pkgs.borgbackup}/bin/borg break-lock ${repo}";
          ExecStart = "${pkgs.writeShellScript "backup" ''
            # FIXME: 
            export BORG_PASSPHRASE="" 
            export BORG_RELOCATED_REPO_ACCESS_IS_OK="yes" 
            export DBUS_SESSION_BUS_ADDRESS="''${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/''${UID}/bus}"

            # some helpers and error handling:
            info() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
            trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

            info "Starting backup"
            ${pkgs.borgbackup}/bin/borg create ${repo}::'{hostname}-{now:%Y-%m-%d@%H:%M}' /home     \
                -v --stats --compression lz4                                                        \
                ${concatMapStrings (s: "--exclude '${globals.envVars.HOME}/${s}' ") common-excludes}
            backup_exit=$?

            info "Pruning repository"
            # Prune the repo of extra backups
            ${pkgs.borgbackup}/bin/borg prune -v ${repo} --prefix '{hostname}-' --show-rc --list    \
                --keep-hourly=1                                                                     \
                --keep-daily=7                                                                      \
                --keep-weekly=4                                                                     \
                --keep-monthly=6                                                                    \
                --keep-yearly=-1                                                                    \
            prune_exit=$?

            # actually free repo disk space by compacting segments
            info "Compacting repository"
            borg compact
            compact_exit=$?            

            # Include the remaining device capacity in the log
            df -hl | grep --color=never /store
            ${pkgs.borgbackup}/bin/borg list ${repo}

            # use highest exit code as global exit code
            global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
            global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

            if [ ''${global_exit} -eq 0 ]; then
                info "Backup, Prune, and Compact finished successfully"
            elif [ ''${global_exit} -eq 1 ]; then
                info "Backup, Prune, and/or Compact finished with warnings"
                ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE finished with warnings!" "Run journalctl -u $SERVICE for details"
            else
                info "Backup, Prune, and/or Compact finished with errors"
                ${pkgs.libnotify}/bin/notify-send -u critical "$SERVICE FAILED!" "Run journalctl -u $SERVICE for details"
            fi

            exit ''${global_exit}
          ''}";
        };
    };
  };
}
