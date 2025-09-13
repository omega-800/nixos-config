{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.cal;
in
{
  options.u.social.cal.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    programs = {
      khal.enable = true;
      vdirsyncer.enable = true;
    };
    services.vdirsyncer.enable = true;
  };
}
