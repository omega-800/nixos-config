{
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.m.wm.river;
  inherit (lib)
    mkOption
    types
    mkIf
    ;
in
{
  options.m.wm.river = {
    enable = mkOption {
      description = "enables river";
      type = types.bool;
      default = usr.wm == "river";
    };
  };
  config = mkIf cfg.enable {
    programs.river-classic = {
      enable = true;
    };
  };
}
