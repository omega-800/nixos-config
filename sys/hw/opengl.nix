{ lib, config, pkgs, sys, ... }:
with lib;
let cfg = config.m.openGL;
in {
  options.m.openGL = { enable = mkEnableOption "enables openGL"; };

  config = mkIf cfg.enable {
    hardware."${if sys.stable then "opengl" else "graphics"}" = {
      enable = true;
      extraPackages = with pkgs; [ rocmPackages.clr.icd ];
    };
  };
}
