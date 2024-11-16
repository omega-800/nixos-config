{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "rust" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      # TODO: change rustaceanvim to none-ls/lsp + dap configs
      lsp.servers = mkIf plugins.lsp.enable { };
      none-ls.sources = mkIf plugins.none-ls.enable { };
      rustaceanvim = {
        enable = true;
        # there are so many settings that i'm getting overwhelmed just by looking at the list
        # let's leave it at the defaults today
        settings = {
          dap.adapter = {
            command = "${pkgs.lldb_19}/bin/lldb-dap";
            type = "executable";
          };
          tools = {
            enable_clippy = true;
            # hover_actions.replace_builtin_hover = true;
            # reload_workspace_from_cargo_toml = true;
          };
          server = {
            # cmd = [
            #   "rustup"
            #   "run"
            #   "nightly"
            #   "rust-analyzer"
            # ];
            default_settings = {
              rust-analyzer = {
                check = {
                  command = "clippy";
                  cargo.allFeatures = true;
                };
                inlayHints = {
                  lifetimeElisionHints.enable = "always";
                  typeHints.enable = true;
                };
              };
            };
            standalone = false;
          };
        };
      };
    };
  };
}
