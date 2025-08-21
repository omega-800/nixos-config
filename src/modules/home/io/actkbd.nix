{
  lib,
  config,
  ...
}:
let
  cfg = config.u.io.actkbd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.u.io.actkbd.enable = mkEnableOption "actkbd";
  config = mkIf cfg.enable {
    #TODO: implement shortcuts
  };
}
