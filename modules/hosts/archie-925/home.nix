{ sys, pkgs, ... }:
{
  u.social.enable = false;
  u.nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
}
