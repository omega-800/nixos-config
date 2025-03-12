{ sys, pkgs, ... }:
{
  u = {
    social.enable = false;
    user.nixvim.langSupport = [
      "sh"
      "hs"
      "rust"
      "md"
      "nix"
      "lua"
      "c"
      "ftl"
    ];
    net = {
      lynx.enable = true;
    };
    nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  };
}
