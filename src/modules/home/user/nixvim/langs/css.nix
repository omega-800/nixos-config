{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "css" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        cssls.enable = true;
        tailwindcss.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics.checkstyle.enable = true;
        formatting = {
          stylelint.enable = true;
          rustywind.enable = true;
        };
      };
    };
  };
}
