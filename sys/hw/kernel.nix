{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.m.kernel;
in {
  options.m.kernel = {
    zen = mkEnableOption "enables zen kernel";
  };

  config = mkIf zen {
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.consoleLogLevel = 0;
  };
}
