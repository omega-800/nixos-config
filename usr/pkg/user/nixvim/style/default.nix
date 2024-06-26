{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>b";
        action = "+buffer";
      }
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>BufferLineCycleNext<cr>";
        options = { desc = "Cycle to next buffer"; };
      }

      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>BufferLineCyclePrev<cr>";
        options = { desc = "Cycle to previous buffer"; };
      }

      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = { desc = "Delete buffer"; };
      }

      {
        mode = "n";
        key = "<leader>bl";
        action = "<cmd>BufferLineCloseLeft<cr>";
        options = { desc = "Delete buffers to the left"; };
      }

      {
        mode = "n";
        key = "<leader>bo";
        action = "<cmd>BufferLineCloseOthers<cr>";
        options = { desc = "Delete other buffers"; };
      }

      {
        mode = "n";
        key = "<leader>bP";
        action = "<cmd>BufferLineTogglePin<cr>";
        options = { desc = "Toggle pin"; };
      }

      {
        mode = "n";
        key = "<leader>bc";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options = { desc = "Delete non-pinned buffers"; };
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
    ];
    plugins = {
      todo-comments.enable = true;
      rainbow-delimiters.enable = true;
      nvim-autopairs.enable = true;
      nvim-colorizer.enable = true;
      wilder = {
        enable = true;
        modes = [ ":" "/" "?" ];
        enableCmdlineEnter = true;
        acceptCompletionAutoSelect = true;
      };
      bufferline = {
        enable = true;
        diagnostics = "nvim_lsp";
        mode = "buffers";

        closeIcon = " ";
        bufferCloseIcon = "󰱝 ";
        modifiedIcon = "󰔯 ";

        offsets = [{
          filetype = "neo-tree";
          text = "Neo-tree";
          highlight = "Directory";
          text_align = "left";
        }];
      };
      lualine = {
        enable = true;
        globalstatus = true;
        extensions = [ "neo-tree" ];
        disabledFiletypes = { statusline = [ "startup" "alpha" ]; };
        #theme = "catppuccin";
        sections = {
          lualine_a = [{ name = "mode"; }];
          lualine_b = [{
            name = "branch";
            icon = "";
          }];
          lualine_c = [
            {
              name = "diagnostics";
              extraConfig = {
                sources = [ "nvim_lsp" ];
                symbols = {
                  error = " ";
                  warn = " ";
                  info = " ";
                  hint = "󰝶 ";
                };
              };
            }
            {
              name = "filetype";
              extraConfig = {
                icon_only = true;
                separator = "";
                padding = {
                  left = 1;
                  right = 0;
                };
              };
            }
            {
              name = "filename";
              extraConfig = { path = 1; };
            }
          ];
          lualine_x = [{
            name = "diff";
            extraConfig = {
              symbos = {
                added = " ";
                modified = " ";
                removed = " ";
              };
              source = {
                __raw = ''
                  function()
                    local gitsings = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitigns.added,
                        modified = gitigns.changed,
                        removed = gitigns.removed
                      }
                    end
                  end
                '';
              };
            };
          }];
          lualine_y = [{ name = "progress"; }];
          lualine_z = [{ name = "location"; }];
        };
      };
      startup = {
        enable = true;

        colors = {
          background = "#ffffff";
          foldedSection = "#ffffff";
        };

        sections = {
          header = {
            type = "text";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Header";
            margin = 5;
            content = [
              " ██████╗ ███╗   ███╗███████╗ ██████╗  █████╗       ██╗   ██╗██╗███╗   ███╗"
              "██╔═══██╗████╗ ████║██╔════╝██╔════╝ ██╔══██╗      ██║   ██║██║████╗ ████║"
              "██║   ██║██╔████╔██║█████╗  ██║  ███╗███████║█████╗██║   ██║██║██╔████╔██║"
              "██║   ██║██║╚██╔╝██║██╔══╝  ██║   ██║██╔══██║╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║"
              "╚██████╔╝██║ ╚═╝ ██║███████╗╚██████╔╝██║  ██║       ╚████╔╝ ██║██║ ╚═╝ ██║"
              " ╚═════╝ ╚═╝     ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝        ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];

            highlight = "Statement";
            defaultColor = "";
            oldfilesAmount = 0;
          };
          body = {
            type = "mapping";
            oldfilesDirectory = false;
            align = "center";
            foldSection = false;
            title = "Menu";
            margin = 5;
            content = [
              [ " Find File" "Telescope find_files" "<leader>ff" ]
              [ "󰍉 Find Word" "Telescope live_grep" "<leader>fr" ]
              [ " Recent Files" "Telescope oldfiles" "<leader>fo" ]
              [ " Git Files" "Telescope git_files" "<leader>fg" ]
            ];
            highlight = "string";
            defaultColor = "";
            oldfilesAmount = 0;
          };
        };
        options = { paddings = [ 1 3 ]; };

        parts = [ "header" "body" ];
      };
    };
  };
}
