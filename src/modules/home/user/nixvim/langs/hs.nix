{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "hs" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      haskell-scope-highlighting.enable = true;
      lsp.servers = mkIf plugins.lsp.enable {
        hls = {
          enable = true;
          installGhc = true;
        };
        # ghcide.enable = true;
      };
    };
  };
}
