{
  lib,
  config,
sys,
  ...
}:
let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.u.utils.less;
in
{
  options.u.utils.less.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable;
  };

  config = mkIf cfg.enable {
    programs.less = mkMerge [{
      enable = true;
    }
    (if (!sys.stable) then {
      config = ''
        s        back-line
        t        forw-line
      '';
    } else {})];
  };
}
