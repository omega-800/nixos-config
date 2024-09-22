{ lib, config, pkgs, sys, ... }:
with lib;
let cfg = config.m.hw.openGL;
in {
  options.m.hw.openGL = { enable = mkEnableOption "enables openGL"; };

  config = mkIf cfg.enable {
    hardware."${if sys.stable then "opengl" else "graphics"}" = {
      enable = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
