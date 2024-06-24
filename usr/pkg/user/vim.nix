{ inputs, config, pkgs, lib, ... }:
with lib; {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  config = mkIf config.u.user.enable {
    #home.packages = with pkgs; [ neovim ];
    programs = {
      nixvim = {
        enable = true;
        withNodeJs = true;
        globals.mapleader = " ";
        extraConfigVim = builtins.readFile ./.vimrc;
        keymaps = [
        {
          mode = "n";
          key = "<leader>co";
          action = "<cmd>TSToolsOrganizeImports<cr>";
          options = {
            desc = "Organize Imports";
          };
        }
        {
          mode = "n";
          key = "<leader>cR";
          action = "<cmd>TSToolsRemoveUnusedImports<cr>";
          options = {
            desc = "Remove Unused Imports";
          };
        }
          # Global
          # Default mode is "" which means normal-visual-op
          {
            key = "<C-n>";
            action = "<CMD>NvimTreeToggle<CR>";
            options.desc = "Toggle NvimTree";
          }
          {
            key = "<leader>c";
            action = "+context";
          }
          {
            key = "<leader>co";
            action = "<CMD>TSContextToggle<CR>";
            options.desc = "Toggle Treesitter context";
          }
          # File
          {
            mode = "n";
            key = "<leader>f";
            action = "+find/file";
          }
          {
            # Format file
            key = "<leader>fm";
            action = "<CMD>lua vim.lsp.buf.format()<CR>";
            options.desc = "Format the current buffer";
          }
          # Git    
          {
            mode = "n";
            key = "<leader>g";
            action = "+git";
          }
          {
            mode = "n";
            key = "<leader>gt";
            action = "+toggles";
          }
          {
            key = "<leader>gtb";
            action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
            options.desc = "Gitsigns current line blame";
          }
          {
            key = "<leader>gtd";
            action = "<CMD>Gitsigns toggle_deleted";
            options.desc = "Gitsigns deleted";
          }
          {
            key = "<leader>gd";
            action = "<CMD>Gitsigns diffthis<CR>";
            options.desc = "Gitsigns diff this buffer";
          }
          {
            mode = "n";
            key = "<leader>gr";
            action = "+resets";
          }
          {
            key = "<leader>grh";
            action = "<CMD>Gitsigns reset_hunk<CR>";
            options.desc = "Gitsigns reset hunk";
          }
          {
            key = "<leader>grb";
            action = "<CMD>Gitsigns reset_buffer<CR>";
            options.desc = "Gitsigns reset current buffer";
          }

          # Tabs
          {
            mode = "n";
            key = "<leader>t";
            action = "+tab";
          }
          {
            mode = "n";
            key = "<leader>tn";
            action = "<CMD>tabnew<CR>";
            options.desc = "Create new tab";
          }
          {
            mode = "n";
            key = "<leader>td";
            action = "<CMD>tabclose<CR>";
            options.desc = "Close tab";
          }
          {
            mode = "n";
            key = "<leader>ts";
            action = "<CMD>tabnext<CR>";
            options.desc = "Go to the sub-sequent tab";
          }
          {
            mode = "n";
            key = "<leader>tp";
            action = "<CMD>tabprevious<CR>";
            options.desc = "Go to the previous tab";
          }
          # Terminal
          {
            # Escape terminal mode using ESC
            mode = "t";
            key = "<esc>";
            action = "<C-\\><C-n>";
            options.desc = "Escape terminal mode";
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
          {
            mode = "n";
            key = "<leader>ut";
            action = "<cmd>UndotreeToggle<CR>";
            options = {
              silent = true;
              desc = "Undotree";
            };
          }
        ];
        plugins = {
          telescope = {
            enable = true;
            keymaps = {
              "<leader>fg" = "live_grep";
              "<C-p>" = {
                action = "git_files";
                options.desc = "Telescope Git Files";
              };
            };
            extensions.fzf-native.enable = true;
          };
          wilder = {
            enable = true;
            modes = [ ":" "/" "?" ];
          };
          harpoon = {
            enable = true;
            enableTelescope = true;
          };
          lsp = {
            enable = true;
            servers = {
              bashls.enable = true;
              clangd.enable = true;
              nixd.enable = true;
              volar.enable = true;
              cssls.enable = true;
              #tailwindcss.enable = true;
              eslint.enable = true;
              graphql.enable = true;
              html.enable = true;
              jsonls.enable = true;
              tsserver.enable = true;
              vuels.enable = true;
              yamlls.enable = true;
              typos-lsp.enable = true;
              lua-ls.enable = true;
              #htmx.enable = true;
              #java-language-server.enable = true;
              dockerls.enable = true;
              docker-compose-language-service.enable = true;
            };
            keymaps.lspBuf = {
              "gd" = "definition";
              "gD" = "references";
              "gt" = "type_definition";
              "gi" = "implementation";
              "K" = "hover";
            };
          };
          lsp-lines = {
            enable = true;
            currentLine = true;
          };
          fidget = {
            enable = true;
            progress = {
              suppressOnInsert = true;
              ignoreDoneAlready = true;
              pollRate = 0.5;
            };
          };
          none-ls = {
            enable = true;
            sources = {
              diagnostics = { statix.enable = true; };
              formatting = {
                fantomas.enable = true;
                nixfmt.enable = true;
                markdownlint.enable = true;
                shellharden.enable = true;
                shfmt.enable = true;
              };
            };
          };
          gitsigns = {
            enable = true;
            settings = {
              current_line_blame = true;
              trouble = true;
            };
          };
          nvim-tree = {
            enable = true;
            openOnSetupFile = true;
            autoReloadOnWrite = true;
          };
          treesitter = {
            enable = true;
            nixGrammars = true;
            indent = true;
          };
          treesitter-context = {
            enable = true;
            settings.max_lines = 2;
          };
          undotree = {
            enable = true;
            settings = {
              autoOpenDiff = true;
              focusOnToggle = true;
            };
          };
          tmux-navigator.enable = true;
          todo-comments.enable = true;
          rainbow-delimiters.enable = true;
          lightline.enable = true;
          trouble.enable = true;
          nvim-autopairs.enable = true;
          bufferline.enable = true;
          nvim-colorizer.enable = true;
          typescript-tools = {
            enable = true;
            onAttach = ''
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
          which-key = {
            enable = true;
            ignoreMissing = false;
            icons = {
              breadcrumb = "»";
              group = "+";
              separator = ""; # ➜
            };
# registrations = {
#   "<leader>t" = " Terminal";
# };
            window = {
              border = "none";
              winblend = 0;
            };
          };
          #https://github.com/MikaelFangel/nixvim-config/blob/main/config/cmp.nix
          #          auto-save = {
          #            enable = true;
          #            enableAutoSave = true;
          #          };
        };
      };
      vim = {
        enable = true;
        #defaultEditor = true;
        settings = {
          background = "dark";
          mousehide = true;
        };
        extraConfig = builtins.readFile ./.vimrc;
      };
    };
  };
}
