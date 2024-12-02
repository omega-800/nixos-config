{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.media.mpd;
in
{
  options.u.media.playerctl.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable;
  };
  config = mkIf cfg.enable {
    services.playerctld = {
      enable = true;
    };
  };
}
