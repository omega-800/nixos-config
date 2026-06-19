{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "ocaml" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        ocamllsp = {
          enable = true;
          # extraOptions = options;
        };
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.ocamlformat.enable = true;
      };
    };
    # TODO: [[ ! -r '/home/omega/.opam/opam-init/init.zsh' ]] || source '/home/omega/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
    extraPlugins =
      let
        name = "ocaml.nvim";
      in
      [
        (pkgs.vimUtils.buildVimPlugin {
          inherit name;
          src = pkgs.fetchFromGitHub {
            repo = name;
            owner = "tarides";
            rev = "d56d551f1b7efbb2ebd250b4701e0a38568cec04";
            hash = "sha256-atRXtqMIhsmwR1INrhbFsywWAgLTbT9bz/LLfcN4Lfg=";
          };
        })
      ];
    extraConfigLua = ''
      require("ocaml").setup({
        params = {
          client = "ocamllsp",
        },
        keymaps = {
          jump_next_hole = "<leader>on",
          jump_prev_hole = "<leader>op",
          construct = "<leader>oc",
          jump = "<leader>oj",
          phrase_prev = "<leader>opp",
          phrase_next = "<leader>opn",
          infer = "<leader>oi",
          switch_ml_mli = "<leader>os",
          type_enclosing = "<leader>ott",
          type_enclosing_grow = "<leader>otg",
          type_enclosing_shrink = "<leader>ots",
          type_enclosing_increase = "<leader>oti",
          type_enclosing_decrease = "<leader>otd",
        },
      })
    '';
  };
}
