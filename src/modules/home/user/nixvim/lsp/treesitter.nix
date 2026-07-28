{
  lib,
  sys,
  pkgs,
  config,
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
          folding.enable = false;
          grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
          # FIXME: TODO:
          # grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
          #   angular
          #   asm
          #   awk
          #   bash
          #   bibtex
          #   c
          #   c-sharp
          #   caddy
          #   clojure
          #   cmake
          #   comment
          #   commonlisp
          #   cpp
          #   css
          #   csv
          #   dart
          #   diff
          #   dockerfile
          #   dot
          #   elixir
          #   elm
          #   erlang
          #   fish
          #   fsharp
          #   git-config
          #   git-rebase
          #   gitcommit
          #   gitignore
          #   gleam
          #   glsl
          #   go
          #   gomod
          #   gosum
          #   gotmpl
          #   gpg
          #   graphql
          #   groovy
          #   haskell
          #   helm
          #   html
          #   http
          #   idris
          #   ini
          #   java
          #   javadoc
          #   javascript
          #   jinja
          #   jq
          #   jsdoc
          #   json
          #   julia
          #   just
          #   kdl
          #   kotlin
          #   latex
          #   llvm
          #   lua
          #   luadoc
          #   make
          #   markdown
          #   nasm
          #   nginx
          #   nim
          #   nix
          #   nu
          #   ocaml
          #   odin
          #   pascal
          #   passwd
          #   perl
          #   php
          #   python
          #   regex
          #   robots-txt
          #   ruby
          #   rust
          #   scala
          #   scheme
          #   scss
          #   sql
          #   ssh-config
          #   strace
          #   svelte
          #   swift
          #   templ
          #   terraform
          #   tmux
          #   toml
          #   tsv
          #   turtle
          #   typst
          #   vim
          #   vue
          #   xml
          #   xresources
          #   yaml
          #   zig
          #   zsh
          # ];
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
