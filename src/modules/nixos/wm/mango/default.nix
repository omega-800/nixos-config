{
  inputs,
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.m.wm.mango;
  inherit (lib)
    mkOption
    types
    mkIf
    ;
in
{
  options.m.wm.mango = {
    enable = mkOption {
      description = "enables mango";
      type = types.bool;
      default = usr.wm == "mango";
    };
  };
  imports = [ inputs.mango.nixosModules.mango ];
  config = mkIf cfg.enable {
    programs.mango.enable = true;
  };
}
