{
  globals,
  usr,
  sys,
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.jetbrains;
in
{
  options.u.dev.jetbrains.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    home.packages = [
      (inputs.nix-jetbrains-plugins.lib.buildIdeWithPlugins pkgs "idea" [
        "IdeaVIM"
        "com.jetbrains.restClient"
      ])
    ];
  };
}
