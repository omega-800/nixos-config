{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.u.io.mouseless;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.u.io.mouseless.enable = mkEnableOption "Enables mouse movements through keyboard input";
  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.nur.repos.wolfangaukang.mouseless ];
      file.".config/mouseless/config.yaml".source = ./config.yaml;
    };
  };
}
