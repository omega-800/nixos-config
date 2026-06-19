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
      khal = {
        enable = true;
        locale = {
          dateformat = "%d.%m.%Y";
          datetimeformat = "%H:%M:%S %a %d %b %Y";
          longdateformat = "%d.%m.%y";
          longdatetimeformat = "%H:%M:%S %d.%m.%y";
          timeformat = "%H:%M:%S";
          firstweekday = 0;
          weeknumbers = "left";
          # default_timezone = "";
        };
      };
      vdirsyncer.enable = true;
    };
    services.vdirsyncer.enable = true;
  };
}
