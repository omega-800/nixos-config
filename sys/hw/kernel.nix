{ config, pkgs, ... }: {
  options = {
    mKernelZen.enable = lib.mkEnableOption "enables zen kernel";
  };

  config = lib.mkIf config.mKernelZen.enable {
    boot.kernelPackages = pkgs.linuxPackages_zen;
    boot.consoleLogLevel = 0;
  };
}
