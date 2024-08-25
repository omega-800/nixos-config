{ lib, config, pkgs, ... }:
with lib;
let cfg = config.m.openGL;
in {
  options.m.openGL = { enable = mkEnableOption "enables openGL"; };

  config = mkIf cfg.enable {
    # OpenGL
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
