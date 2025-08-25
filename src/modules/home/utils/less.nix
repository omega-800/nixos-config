{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.less;
in
{
  options.u.utils.less.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable;
  };

  config = mkIf cfg.enable {
    programs.less = {
      enable = true;
      config = ''
        s        back-line
        t        forw-line
      '';
    };
  };
}
