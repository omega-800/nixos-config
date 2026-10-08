{
  config,
  lib,
  sys,
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
    home.packages = with pkgs; [ typst ];
    programs.nixvim = {
      plugins = {
        lsp.servers = mkIf plugins.lsp.enable {
          tinymist = {
            enable = true;
            settings.syntaxOnly = if elem "builder" sys.flavors then "disable" else "enable";
          };
        };
        none-ls.sources = mkIf plugins.none-ls.enable {
          formatting.typstyle = {
            enable = true;
            # laggy :(
            settings.extra_args = optionals (elem "builder" sys.flavors) [ "--wrap-text" ];
          };
        };
      };
    };
  };
}
