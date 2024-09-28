{ lib, config, ... }:
with lib;
let cfg = config.m.fs.automount;
in {
  options.m.fs.automount = {
    enable = mkOption {
      description = "enables automount";
      type = types.bool;
      default = config.m.fs.enable;
    };
  };

  config = mkIf cfg.enable {
    # services.devmon.enable = true;
    # services.gvfs.enable = true;
    services.udisks2.enable = true;
  };
}
