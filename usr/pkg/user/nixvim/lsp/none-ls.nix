{
  programs.nixvim = {
    keymaps = [
      # Format file
      {
        key = "<leader>=";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format the current buffer";
      }
    ];

    plugins.none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          statix.enable = true;
          gitlint.enable = true;
          golangci_lint.enable = true;
          zsh.enable = true;
        };
        formatting = {
          fantomas.enable = true;
          nixfmt.enable = true;
          nixpkgs_fmt.enable = true;
          pg_format.enable = true;
          sqlfluff.enable = true;
          stylelint.enable = true;
          yamlfix.enable = true;
          gofmt.enable = true;
          goimports.enable = true;
          prettierd = {
            enable = true;
            withArgs = # lua
              ''
                {
                  filetypes = {
                    -- "javascript", -- now done by biome
                    -- "javascriptreact", -- now done by biome
                    -- "typescript", -- now done by biome
                    -- "typescriptreact", -- now done by biome
                    -- "json", -- now done by biome
                    -- "jsonc", -- now done by biome
                    "vue",
                    "css",
                    "scss",
                    "less",
                    "html",
                    "yaml",
                    "markdown",
                    "markdown.mdx",
                    "graphql",
                    "handlebars",
                  },
                }
              '';
          };
          biome.enable = true;
          markdownlint.enable = true;
          mdformat.enable = true;
          shellharden.enable = true;
          shfmt.enable = true;
          clang_format.enable = true;
          htmlbeautifier.enable = true;
        };
      };
    };
  };
}
