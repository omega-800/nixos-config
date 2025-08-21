{
  lib,
  config,
  pkgs,
  sys,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.m.hw.openGL;
in
{
  options.m.hw.openGL.enable = mkEnableOption "openGL";

  config = mkIf cfg.enable {
    hardware."${if sys.stable then "opengl" else "graphics"}" = {
      enable = true;
      #TODO: figure out right pkgs
      extraPackages = with pkgs; [
        rocmPackages.clr.icd
        intel-media-driver
        (if sys.stable then openvps-intel-gpu else vpl-gpu-rt)
      ];
    };
    environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
  };
}
