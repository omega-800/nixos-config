{
  usr,
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.slop;
in
{
  options.u.dev.slop.enable = mkOption {
    type = types.bool;
    default = /* config.u.dev.enable && usr.extraBloat */ false;
  };

  config = mkIf cfg.enable {
    services.ollama.enable = true;
    programs.opencode = {
      enable = true;
      web.enable = false;
      enableMcpIntegration = true;
      settings = {
        autoshare = false;
        autoupdate = false;
      };
    };
    home.packages = with pkgs; [
      ollama
    ];
  };
}
