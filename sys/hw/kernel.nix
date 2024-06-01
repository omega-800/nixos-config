{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.kernel;
in {
  options.m.kernel = {
    zen = mkEnableOption "enables zen kernel";
  };

  config = mkIf cfg.zen {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    boot.consoleLogLevel = 0;
    # boot.kernelModules = [ "i2c-dev" "i2c-piix4" "cpufreq_powersave" ];
  };
}
