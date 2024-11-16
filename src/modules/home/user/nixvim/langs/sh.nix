{
  config,
  lib,
  usr,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "sh" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        bashls.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics = {
          zsh.enable = usr.shell.pname == "zsh";
        };
        formatting = {
          shellharden.enable = true;
          shfmt.enable = true;
        };
      };
    };
  };
}
