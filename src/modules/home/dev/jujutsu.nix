{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.jujutsu;
in
{
  options.u.dev.jujutsu.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    programs = {
      jujutsu = {
        enable = true;
        settings = {
          ui.default-command = "log";
          user = {
            name = usr.devName;
            email = usr.devEmail;
          };
          init.defaultBranch = "main";
        };
      };
      delta = {
        enable = true;
        enableJujutsuIntegration = true;
      };
    };
  };
}
