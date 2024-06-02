{ inputs, config, pkgs, lib, ... }:
with lib; {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  config = mkIf config.u.user.enable {
    #home.packages = with pkgs; [ neovim ];
    programs = {
      nixvim = {
        enable = true;
        globals.mapleader = " ";
        extraConfigVim = builtins.readFile ./.vimrc;
        keymaps = [
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
        ];
        plugins = {
          tmux-navigator.enable = true;
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
          rainbow-delimiters.enable = true;
          lightline.enable = true;
          trouble.enable = true;
          nvim-autopairs.enable = true;
          bufferline.enable = true;
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
