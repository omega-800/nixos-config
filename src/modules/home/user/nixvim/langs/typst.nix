{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf optionals;
  inherit (builtins) elem;
  enabled = elem "typst" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config = mkIf enabled {
    home.packages = with pkgs; [
      fira-math
      typst
    ];
    programs.nixvim = {
      plugins = {
        lsp.servers = mkIf plugins.lsp.enable {
          tinymist.enable = true;
        };
        none-ls.sources = mkIf plugins.none-ls.enable {
          formatting.typstyle.enable = true;
        };
      };
    };
  };
}
