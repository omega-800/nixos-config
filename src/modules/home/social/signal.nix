{
  globals,
  config,
  usr,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.signal;
in
{
  options.u.social.signal.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    programs = {
      gurk-rs = {
        enable = true;
        settings = {}; # TODO: 
      };
    };
  };
}
