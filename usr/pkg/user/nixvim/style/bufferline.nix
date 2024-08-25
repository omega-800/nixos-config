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
        key = "<leader>bN";
        action = "<cmd>BufferLineMoveNext<cr>";
      }

      {
        mode = "n";
        key = "<leader>bP";
        action = "<cmd>BufferLineMovePrev<cr>";
      }

      {
        mode = "n";
        key = "<leader>bs";
        action = "<Cmd>BufferLinePick<CR>";
        options = { desc = "Select buffer"; };
      }

      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options = { desc = "Delete buffer"; };
      }

      {
        mode = "n";
        key = "<leader>br";
        action = "<cmd>BufferLineCloseRight<cr>";
        options = { desc = "Delete buffers to the right"; };
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
        key = "<leader>bs";
        action = "+buffer sort";
        options = { desc = "Sort buffers"; };
      }
      {
        mode = "n";
        key = "<leader>bsd";
        action = "<cmd>BufferLineSortByDirectory<cr>";
      }
      {
        mode = "n";
        key = "<leader>bse";
        action = "<cmd>BufferLineSortByExtension<cr>";
      }
      {
        mode = "n";
        key = "<leader>bst";
        action = "<cmd>BufferLineSortByTabs<cr>";
      }

      {
        mode = "n";
        key = "<leader>bt";
        action = "<cmd>BufferLineTogglePin<cr>";
        options = { desc = "Toggle pin"; };
      }

      {
        mode = "n";
        key = "<leader>bC";
        action = "<Cmd>BufferLineGroupClose ungrouped<CR>";
        options = { desc = "Delete non-pinned buffers"; };
      }
    ];
    plugins.bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        truncate_names = true;
        offsets = [{
          filetype = "neo-tree";
          text = "Neo-tree";
          highlight = "Directory";
          text_align = "left";
        }];
        mode = "buffers";
        close_icon = " ";
        buffer_close_icon = "󰱝 ";
        modified_icon = "󰔯 ";
      };
    };
  };
}
