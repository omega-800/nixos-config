{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "dart" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        dartls = {
          enable = true;
          settings = {
            filetypes = [ "dart" ];
          };
        };
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.dart_format.enable = true;
      };
      flutter-tools = {
        enable = true;
        autoLoad = true;
      };
    };
  };
}
