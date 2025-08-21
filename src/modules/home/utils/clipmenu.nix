{
  lib,
  usr,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.clipmenu;
in
{
  options.u.utils.clipmenu.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    services.clipmenu = {
      enable = true;
      launcher = "rofi";
    };
  };
}
