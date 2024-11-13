{ sys, pkgs, ... }:
{
  u = {
    social.enable = false;
    net.lynx.enable = true;
    nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  };
}
