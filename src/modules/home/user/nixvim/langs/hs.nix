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
      haskell-tools = {
        enable = true;
        autoLoad = true;
        enableTelescope = true;
        settings = {
          hls = {
            default_settings = {
              haskell = {
                formattingProvider = "ormolu";
                plugin = {
                  hlint = {
                    codeActionsOn = false;
                    diagnosticsOn = false;
                  };
                  importLens = {
                    codeActionsOn = false;
                    codeLensOn = false;
                    globalOn = false;
                  };
                };
              };
            };
          };
        };
      };
      # haskell-scope-highlighting.enable = true;
      # lsp.servers = mkIf plugins.lsp.enable {
      #   hls = {
      #     enable = true;
      #     installGhc = true;
      #     autostart = true;
      #     filetypes = [
      #       "haskell"
      #       "lhaskell"
      #       "cabal"
      #     ];
      #     cmd = [
      #       "haskell-language-server-wrapper"
      #       "--lsp"
      #     ];
      #     settings = {
      #       haskell = {
      #         cabalFormattingProvider = "cabalfmt";
      #         formattingProvider = "ormolu";
      #       };
      #     };
      #   };
      #   # ghcide.enable = true;
      # };
    };
  };
}
