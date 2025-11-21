{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "yaml" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        # yamlls.enable = true;
        # docker_compose_language_service.enable = elem "docker" config.u.user.nixvim.langSupport;
        # ansiblels.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics = {
          # ansiblelint.enable = true;
          # yamllint.enable = true;
        };
        # formatting.yamlfix.enable = true;
      };
    };
  };
}
