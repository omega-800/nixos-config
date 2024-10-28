{ config, lib, pkgs, ... }: {
  programs.nixvim =
    lib.mkIf (builtins.elem "rust" config.u.user.nixvim.langSupport) {
      plugins = {
        # conform-nvim = {
        #   enable = true;
        #   settings = { formatters_by_ft.rust = [ "rustfmt" ]; };
        # };

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
              hover_actions.replace_builtin_hover = true;
              enable_clippy = true;
              reload_workspace_from_cargo_toml = true;
            };
            server = {
              cmd = [ "rustup" "run" "nightly" "rust-analyzer" ];
              default_settings = {
                rust-analyzer = {
                  check = { command = "clippy"; };
                  inlayHints = {
                    lifetimeElisionHints = { enable = "always"; };
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
