{
  lib,
  config,
  globals,
  ...
}:
let
  cfg = config.u.dev.docker;
  inherit (lib)
    types
    mkIf
    mkOption
    ;
in
{
  options.u.dev.docker = {
    enable = mkOption {
      description = "enables docker";
      type = types.bool;
      default = config.u.dev.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.docker-cli = {
      enable = true;
      configDir = "${globals.envVars.XDG_CONFIG_HOME}/docker";
      settings = {}; # TODO: 
    };
  };
}
