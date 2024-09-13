{ lib, sys, usr, config, ... }:
with lib;
with builtins;
let langs = config.u.user.nixvim.langSupport;
in {
  programs.nixvim = {
    keymaps = [
      # Format file
      {
        key = "<leader>=";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format the current buffer";
      }
    ];

    plugins.none-ls = lib.mkMerge [
      (if sys.stable then
        { }
      else {
        sources.formatting.prettierd = {
          enable = true;
          settings = # lua
            ''
              {
                filetypes = {
                  -- "javascript", -- now done by biome
                  -- "javascriptreact", -- now done by biome
                  -- "typescript", -- now done by biome
                  -- "typescriptreact", -- now done by biome
                  -- "json", -- now done by biome
                  -- "jsonc", -- now done by biome
                  ${
                    if (elem "js" langs) then ''
                      "vue",
                    '' else
                      ""
                  }
                  ${
                    if (elem "css" langs) then ''
                      "css",
                      "scss",
                      "less",
                    '' else
                      ""
                  }
                  ${
                    if (elem "yaml" langs) then ''
                      "yaml",
                    '' else
                      ""
                  }
                  ${
                    if (elem "md" langs) then ''
                      "markdown",
                      "markdown.mdx",
                    '' else
                      ""
                  }
                  ${
                    if (elem "gql" langs) then ''
                      "graphql",
                    '' else
                      ""
                  }
                  ${
                    if (elem "html" langs) then ''
                      "html",
                    '' else
                      ""
                  }
                },
              }
            '';
        };
      })
      ({
        enable = true;
        sources = {
          diagnostics = mkMerge [
            {
              gitlint.enable = true;
              todo_comments.enable = true;
              #dotenv_linter.enable = true;
              zsh.enable = usr.shell.pname == "zsh";
            }
            (mkIf (elem "sql" langs) { sqlfluff.enable = true; })
            (mkIf (elem "go" langs) { golangci_lint.enable = true; })
            (mkIf (elem "rust" langs) { ltrs.enable = true; })
            (mkIf (elem "nix" langs) { statix.enable = true; })
            (mkIf (elem "python" langs) { pylint.enable = true; })
            (mkIf (elem "css" langs) { checkstyle.enable = true; })
            (mkIf (elem "c" langs) {
              cppcheck.enable = true;
              checkmake.enable = true;
            })
            (mkIf (elem "yaml" langs) {
              ansiblelint.enable = true;
              yamllint.enable = true;
            })
          ];
          formatting = mkMerge [
            { codespell.enable = true; }
            (mkIf (elem "nix" langs) {
              nixfmt.enable = true;
              nixpkgs_fmt.enable = true;
            })
            (mkIf (elem "sql" langs) {
              pg_format.enable = true;
              sqlfluff.enable = true;
            })
            (mkIf (elem "go" langs) {
              #gofmt.enable = true;
              #goimports.enable = true;
            })
            (mkIf (elem "js" langs) { biome.enable = true; })
            (mkIf (elem "md" langs) {
              markdownlint.enable = true;
              mdformat.enable = true;
            })
            (mkIf (elem "sh" langs) {
              shellharden.enable = true;
              shfmt.enable = true;
            })
            (mkIf (elem "c" langs) {
              clang_format.enable = true;
              cmake_format.enable = true;
            })
            (mkIf (elem "yaml" langs) { yamlfix.enable = true; })
            (mkIf (elem "java" langs) { google_java_format.enable = true; })
            (mkIf (elem "html" langs) { htmlbeautifier.enable = true; })
            (mkIf (elem "css" langs) {
              stylelint.enable = true;
              rustywind.enable = true;
            })
          ];
        };
      })
    ];
  };
}
