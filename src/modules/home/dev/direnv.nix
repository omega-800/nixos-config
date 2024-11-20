{
  lib,
  config,
  ...
}:
let
  cfg = config.u.dev.direnv;
  inherit (lib) types mkIf mkOption;
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
        load_dotenv = false;
      };
      nix-direnv.enable = true;
    };
  };
}
