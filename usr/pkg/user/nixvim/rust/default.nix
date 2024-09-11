{ config, lib, ... }: {
  programs.nixvim =
    lib.mkIf (builtins.elem "rust" config.u.user.nixvim.langSupport) {
      plugins.rustaceanvim = {
        enable = true;
        # there are so many settings that i'm getting overwhelmed just by looking at the list
        # let's leave it at the defaults today
        settings = {
          tools = {
            hover_actions.replace_builtin_hover = true;
            enable_clippy = true;
            reload_workspace_from_cargo_toml = true;
          };
          server = {
            cmd = [ "rustup" "run" "nightly" "rust-analyzer" ];
            default_settings = {
              rust-analyzer = {
                check = { command = "clippy"; };
                inlayHints = { lifetimeElisionHints = { enable = "always"; }; };
              };
            };
            standalone = false;
          };
        };
      };
    };
}
