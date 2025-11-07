{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "java" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config = mkIf enabled {
    home.packages = with pkgs; [ maven ];
    programs = {
      java.enable = true;
      nixvim = {
        # extraPlugins = [ pkgs.vimPlugins.nvim-java-test ];
        plugins = {
          # java.enable = false;
          lsp.servers = mkIf plugins.lsp.enable {
            # java_language_server.enable = true;
            jdtls = {
              enable = true;
              settings.extra_args = [
                "-c"
                "/google_checks.xml"
              ];
            };
          };
          none-ls.sources = mkIf plugins.none-ls.enable {
            formatting.google_java_format.enable = true;
          };
        };
      };
    };
  };
}
