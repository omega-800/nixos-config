{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "go" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        gopls.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics.golangci_lint.enable = true;
        formatting = {
          gofmt.enable = true;
          #goimports.enable = true;
        };
      };
      # dap.extensions.dap-go.enable = true;
    };
  };
}
