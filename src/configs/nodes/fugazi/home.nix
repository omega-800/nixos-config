{ pkgs, ... }:
{
  u = {
    media.spicetify.enable = true;
    dev.jetbrains.enable = true;
    user.nixvim.langSupport = [
      "c"
      "hs"
      "java"
      "md"
      "nix"
      "plantuml"
      "python"
      "rust"
      "sh"
      "sql"
      "typst"
      "zig"
      "http"
      # "yaml"
      # "css"
      # "dart"
      # "docker"
      # "erlang"
      # "ftl"
      # "go"
      # "gql"
      # "js"
      # "html"
      # "latex"
      # "lisp"
      # "lua"
    ];
  };
  home.packages = with pkgs; [
    superTuxKart
    superTux
  ];
}
