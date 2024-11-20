{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "java" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        java_language_server.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.google_java_format.enable = true;
      };
    };
  };
}
