{
  lib,
  config,
  globals,
  sys,
  ...
}:
let
  cfg = config.u.dev.direnv;
  inherit (lib)
    types
    mkIf
    mkOption
    optionals
    ;
in
{
  options.u.dev.direnv = {
    enable = mkOption {
      description = "enables dev packages";
      type = types.bool;
      default = config.u.dev.enable;
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      config = {
        strict_env = true;
        load_dotenv = true;
        whitelist.prefix =
          with globals.envVars;
          (
            [
              NIXOS_CONFIG
            ]
            ++ (optionals (sys.profile == "work") [
              "${WORKSPACE_DIR}/work/webview"
            ])
            ++ (optionals (sys.profile == "pers") [
              "${WORKSPACE_DIR}/code"
            ])
            ++ (optionals (sys.profile == "school") [
              "${WORKSPACE_DIR}/school"
              "${WORKSPACE_DIR}/pers"
            ])
          );
      };
      nix-direnv.enable = true;
    };
  };
}
