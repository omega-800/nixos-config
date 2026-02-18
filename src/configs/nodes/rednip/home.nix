{ pkgs, ... }:
{
  #  u.nixGLPrefix = "${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel";
  u.user.nixvim.langSupport = [
    "typst"
    "latex"
    "java"
    "yaml"
    "python"
    "html"
    "hs"
    "docker"
    "sql"
    "sh"
    "md"
    "nix"
    "lua"
    "plantuml"
    "zig"
    "idris"
  ];
  # TODO: 
  # home.packages = with pkgs; [ (jetbrains.plugins.addPlugins  jetbrains.idea ["ideavim"]) ];
}
