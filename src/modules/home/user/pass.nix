{
  usr,
  lib,
  config,
  pkgs,
  globals,
  ...
}:
let
  cfg = config.u.user.pass;
  inherit (lib)
    mkOption
    mkIf
    optionals
    types
    ;
in
{
  options.u.user.pass.enable = mkOption {
    description = "enables pass";
    type = types.bool;
    default = config.u.user.enable;
  };

  config = mkIf cfg.enable {
    programs = {
      password-store = {
        enable = true;
        settings = {
          inherit (globals.envVars) PASSWORD_STORE_DIR EDITOR;
          PASSWORD_STORE_CLIP_TIME = "60";
          PASSWORD_STORE_GENERATED_LENGTH = "32";
        };
        package = pkgs.pass.withExtensions (
          exts: with exts; [
            pass-checkup
            pass-otp
          ]
        );
      };
      browserpass.enable = true;
    };
    services.pass-secret-service = {
      enable = true;
      storePath = globals.envVars.PASSWORD_STORE_DIR;
    };
  };
}
