{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkBefore;
  inherit (builtins) elem;
  enabled = elem "typst" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.home.packages = mkIf enabled [ pkgs.typst ];
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        tinymist.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.typstfmt.enable = true;
      };
    };
  };
}
