{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "nix" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        nixd = {
          enable = true;
          # extraOptions = options;
        };
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.nixfmt = {
          enable = true;
          package = pkgs.nixfmt-rfc-style;
        };
        code_actions.statix.enable = true;
        diagnostics.statix.enable = true;
      };
      treesitter.nixGrammars = true;
    };
  };
}
