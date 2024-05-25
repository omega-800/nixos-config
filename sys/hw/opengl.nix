{ lib, config, pkgs, ... }: {
  options = {
    mOpenGL.enable = lib.mkEnableOption "enables OpenGL";
  };
  
  config = lib.mkIf config.mOpenGL.enable {
    # OpenGL
    hardware.opengl.enable = true;
    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };
}
