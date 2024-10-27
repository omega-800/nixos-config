{ pkgs, lib, config, ... }:
let
  cfg = config.u.io.actkbd;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.u.io.actkbd.enable = mkEnableOption "Enables actkbd";
  config = mkIf cfg.enable {
    #TODO: implement shortcuts
  };
}
