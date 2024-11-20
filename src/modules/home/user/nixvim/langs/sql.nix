{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "sql" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        sqls.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics.sqlfluff.enable = true;
        formatting = {
          pg_format.enable = true;
          sqlfluff.enable = true;
        };
      };
    };
  };
}
