{ sys, pkgs, ... }:
{
  u = {
    social.enable = false;
    user.nixvim.langSupport = [
      "sh"
      "md"
      "nix"
      "lua"
      "c"
    ];
    net = {
      lynx.enable = true;
    };
    nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  };
}
