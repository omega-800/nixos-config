{ sys, pkgs, ... }: {
  u = {
    social.enable = false;
    nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  };
}
