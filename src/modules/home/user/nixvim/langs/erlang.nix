{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "erlang" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable { };
      none-ls.sources = mkIf plugins.none-ls.enable { };
    };
  };
}
