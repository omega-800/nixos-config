{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkBefore optionals;
  inherit (builtins) elem;
  enabled = elem "plantuml" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.home.packages = optionals enabled [ pkgs.plantuml ];
  config.programs.nixvim = mkIf enabled {
    dependencies.plantuml.enable = true;
    plugins = {
      plantuml-syntax = {
        enable = true;
        settings = {
          executable_script = "plantuml";
          set_makeprg = true;
        };
      };
    };
  };
}
