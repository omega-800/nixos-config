{ lib, config, pkgs, sys, ... }:
with lib;
let cfg = config.m.hw.openGL;
in {
  options.m.hw.openGL = { enable = mkEnableOption "enables openGL"; };

  config = mkIf cfg.enable {
    hardware."${if sys.stable then "opengl" else "graphics"}" = {
      enable = true;
      #TODO: figure out right pkgs
      extraPackages = (with pkgs; [ rocmPackages.clr.icd intel-media-driver ])
        ++ (if sys.stable then
          (with pkgs; [ openvps-intel-gpu ])
        else
          (with pkgs; [ vpl-gpu-rt ]));
    };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };
  };
}
