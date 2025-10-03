{
  pkgs,
  config,
  usr,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.file.trash;

  trashScript = "${pkgs.clear_trash}";
in
{
  options.u.file.trash.enable = mkOption {
    type = types.bool;
    default = config.u.file.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ trash-cli ];
    systemd.user = {
      services.clean-trash = {
        Unit.Description = "Clean trash older than 7 days";
        Install.WantedBy = [ "default.target" ];
        Service = {
          Type = "oneshot";
          ExecStart = "${pkgs.trash-cli}/bin/trash-empty 7";
        };
      };
      timers.clean-trash = {
        Unit.Description = "Clean trash every day";
        Install.WantedBy = [ "timers.target" ];
        Timer = {
          Unit = "clean-trash.service";
          OnBootSec = "1m";
          OnUnitActiveSec = "24h";
        };
      };
    };
  };
}
