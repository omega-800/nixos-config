{ ... }:
with lib;
let cfg = config.m.automount;
in {
  options.m.automount = {
    enable = mkEnableOption "enables automount";
  };
 
  config = mkIf cfg.enable {
    # services.devmon.enable = true;
    # services.gvfs.enable = true;
    services.udisks2.enable = true;
  }
}
