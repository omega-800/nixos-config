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
            # TODO: specialisations
            ++ (optionals (builtins.elem "work" sys.profile) [
              "${WORKSPACE_DIR}/work/webview"
            ])
            ++ (optionals (builtins.elem "work" sys.profile) [
              "${WORKSPACE_DIR}/code"
            ])
            ++ (optionals (builtins.elem "school" sys.profile) [
              "${WORKSPACE_DIR}/school"
              "${WORKSPACE_DIR}/pers"
            ])
          );
      };
      nix-direnv.enable = true;
    };
  };
}
