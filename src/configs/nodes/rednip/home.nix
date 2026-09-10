{ pkgs, ... }:
{
  u.user.nixvim.langSupport = [
    "c"
    "typst"
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
    "ocaml"
  ];
  u.net.servo.enable = true;
  u.dev.slop.enable = true;
  services.kanshi.settings = [
    { output.criteria = "LVDS-1"; }
    {
      profile.name = "home";
      profile.outputs = [
        {
          criteria = "LVDS-1";
          status = "enable";
        }
        {
          criteria = "VGA-2";
          status = "enable";
        }
      ];
    }
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "LVDS-1";
          status = "enable";
        }
      ];
    }
  ];
}
