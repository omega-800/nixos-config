{ pkgs, ... }: {
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>g";
        action = "+goto";
      }
      # Format file
      {
        key = "<leader>=";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
        options.desc = "Format the current buffer";
      }
      # Trouble 
      {
        mode = "n";
        key = "<leader>d";
        action = "+diagnostics/debug";
      }
      {
        key = "<leader>dt";
        action = "<CMD>TroubleToggle<CR>";
        options.desc = "Toggle trouble";
      }
      # Treesitter
      {
        key = "<leader>c";
        action = "+context";
      }
      {
        key = "<leader>co";
        action = "<CMD>TSContextToggle<CR>";
        options.desc = "Toggle Treesitter context";
      }
      # lsp
      {
        mode = "n";
        key = "<leader>l";
        action = "+lsp";
      }
      {
        mode = "n";
        key = "<leader>lt";
        action = "+typescript";
      }
      {
        mode = "n";
        key = "<leader>lto";
        action = "<cmd>TSToolsOrganizeImports<cr>";
        options = { desc = "Organize Imports"; };
      }
      {
        mode = "n";
        key = "<leader>ltr";
        action = "<cmd>TSToolsRemoveUnusedImports<cr>";
        options = { desc = "Remove Unused Imports"; };
      }
    ];
    plugins = {
      lsp = {
        enable = true;
        servers = {
          marksman.enable = true;
          typos-lsp.enable = true;
          nixd.enable = true;
          bashls.enable = true;

          eslint.enable = true;
          #tsserver.enable = true;
          volar.enable = true;
          #vuels.enable = true;
          jsonls.enable = true;
          cssls.enable = true;
          #tailwindcss.enable = true;
          html.enable = true;
          #htmx.enable = true;
          graphql.enable = true;
          dockerls.enable = true;
          docker-compose-language-service.enable = true;
          ansiblels.enable = true;
          yamlls.enable = true;
          sqls.enable = true;

          lua-ls.enable = true;
          pylsp.enable = true;
          clangd.enable = true;
          cmake.enable = true;
          #java-language-server.enable = true;
        };
        keymaps = {
          diagnostic = {
            "<leader>ln" = "goto_next";
            "<leader>lp" = "goto_prev";
          };
          lspBuf = {
            "K" = "hover";
            "gd" = "definition";
            "gD" = "references";
            "gt" = "type_definition";
            "gi" = "implementation";
          };
          extra = [
            {
              action = "<CMD>LspStop<Enter>";
              key = "<leader>lx";
            }
            {
              action = "<CMD>LspStart<Enter>";
              key = "<leader>ls";
            }
            {
              action = "<CMD>LspRestart<Enter>";
              key = "<leader>lr";
            }
          ];
        };
      };
      typescript-tools = {
        enable = true;
        onAttach = # lua
          ''
            function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false

            if vim.lsp.inlay_hint then
              vim.lsp.inlay_hint(bufnr, true)
                end
                end
          '';
        settings = {
          tsserverFilePreferences = {
            # Inlay Hints
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
        };
      };
      lsp-lines = {
        enable = true;
        currentLine = true;
      };
      lsp-format.enable = true;
      treesitter = {
        enable = true;
        nixGrammars = true;
        indent = true;
        folding = false;
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };
      treesitter-context = {
        enable = true;
        settings.max_lines = 2;
      };
      treesitter-textobjects = {
        enable = false;
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
          swapNext = { "<leader>a" = "@parameters.inner"; };
          swapPrevious = { "<leader>A" = "@parameter.outer"; };
        };
      };
      trouble.enable = true;
      none-ls = {
        enable = true;
        sources = {
          diagnostics = { statix.enable = true; };
          formatting = {
            fantomas.enable = true;
            nixfmt.enable = true;
            nixpkgs_fmt.enable = true;
            pg_format.enable = true;
            sqlfluff.enable = true;
            stylelint.enable = true;
            yamlfix.enable = true;
            prettier.enable = true;
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
  };
}
