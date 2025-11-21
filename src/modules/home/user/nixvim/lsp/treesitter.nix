{
  lib,
  sys,
  pkgs,
  ...
}:
let
  inherit (lib.omega.vim) keyG key;
in
{
  programs.nixvim = {
    keymaps = keyG "<leader>c" "context" [
      (key "n" "o" "<CMD>TSContextToggle<CR>" "Toggle Treesitter context")
      (key "n" "n" "<CMD>cnext<CR>" "Next quickfix")
      (key "n" "p" "<CMD>cprev<CR>" "Previous quickfix")
      (key "n" "o" "<CMD>copen<CR>" "Open quickfix")
      (key "n" "c" "<CMD>cclose<CR>" "Close quickfix")
    ];

    plugins = {
      web-devicons.enable = true;
      treesitter = lib.mkMerge [
        {
          enable = true;
          nixvimInjections = true;
          folding = false;
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        }
        (if sys.stable then { } else { settings.indent.enable = true; })
      ];
      treesitter-context = {
        enable = true;
        settings.max_lines = 2;
      };
      treesitter-textobjects = {
        enable = false;
        settings = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "aa" = "@parameter.outer";
              "ia" = "@parameter.inner";
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
              "ii" = "@conditional.inner";
              "ai" = "@conditional.outer";
              "il" = "@loop.inner";
              "al" = "@loop.outer";
              "at" = "@comment.outer";
            };
          };
          move = {
            enable = true;
            gotoNextStart = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            gotoNextEnd = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            gotoPreviousStart = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            gotoPreviousEnd = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
          swap = {
            enable = true;
            swapNext = {
              "<leader>a" = "@parameters.inner";
            };
            swapPrevious = {
              "<leader>A" = "@parameter.outer";
            };
          };
        };
      };
    };
  };
}
