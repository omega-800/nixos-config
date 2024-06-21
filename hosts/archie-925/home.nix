{ nixGL, sys, ... }:
{
  u.social.enable = false;
  nixGLPrefix = "${nixGL.packages.${sys.system}.nixGLIntel}/bin/nixGLIntel";
}
