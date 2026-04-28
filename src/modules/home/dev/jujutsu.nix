{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.jujutsu;
in
{
  options.u.dev.jujutsu.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    programs.jujutsu = {
      enable = true;
    };
  };
}
