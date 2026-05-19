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
    programs.nixvim = {
      # extraPlugins = [ pkgs.vimPlugins.nvim-java-test ];
      plugins = {
        jdtls = {
          enable = true;
          settings = {
            cmd = [
              "jdtls"
              {
                __raw = "'-data '.. os.getenv('HOME') .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')";
              }
            ];
            root_dir = {
              __raw = "vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1])";
            };
          };
        };
        # java.enable = true;
        lsp.servers = mkIf plugins.lsp.enable {
          # jdtls = {
          #   enable = true;
          #   settings.extra_args = [
          #     # "-c"
          #     # "/google_checks.xml"
          #   ];
          # };
        };
        none-ls.sources = mkIf plugins.none-ls.enable {
          formatting.google_java_format.enable = true;
        };
      };
    };
  };
}
