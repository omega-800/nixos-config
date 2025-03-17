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
          autostart = true;
          filetypes = [
            "haskell"
            "lhaskell"
            "cabal"
          ];
          cmd = [
            "haskell-language-server-wrapper"
            "--lsp"
          ];
          settings = {
            haskell = {
              cabalFormattingProvider = "cabalfmt";
              formattingProvider = "ormolu";
            };
          };
        };
        # ghcide.enable = true;
      };
    };
  };
}
