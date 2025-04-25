{ lib, sys, ... }:
let
  inherit (lib.omega.vim) keyG key;
in
{
  programs.nixvim = lib.mkIf (!sys.stable) {
    keymaps =
      [
        (key "n" "<C-n>" "<cmd>BufferLineCycleNext<cr>" "Cycle to next buffer")
        (key "n" "<C-p>" "<cmd>BufferLineCyclePrev<cr>" "Cycle to previous buffer")
      ]
      ++ (
        keyG "<leader>b" "buffer" [
          (key "n" "n" "<cmd>BufferLineCycleNext<cr>" "Cycle to next buffer")
          (key "n" "p" "<cmd>BufferLineCyclePrev<cr>" "Cycle to previous buffer")
          (key "n" "N" "<cmd>BufferLineMoveNext<cr>" "")
          (key "n" "P" "<cmd>BufferLineMovePrev<cr>" "")
          (key "n" "e" "<Cmd>BufferLinePick<CR>" "Select buffer")
          (key "n" "d" "<cmd>bprevious|bdelete #<cr>" "Delete buffer")
          (key "n" "r" "<cmd>BufferLineCloseRight<cr>" "Delete buffers to the right")
          (key "n" "l" "<cmd>BufferLineCloseLeft<cr>" "Delete buffers to the left")
          (key "n" "o" "<cmd>BufferLineCloseOthers<cr>" "Delete other buffers")
          (key "n" "C" "<Cmd>BufferLineGroupClose ungrouped<CR>" "Delete non-pinned buffers")
          (key "n" "t" "<cmd>BufferLineTogglePin<cr>" "Toggle pin")
        ]
        ++ (keyG "s" "buffer sort" [
          (key "n" "d" "<cmd>BufferLineSortByDirectory<cr>" "")
          (key "n" "e" "<cmd>BufferLineSortByExtension<cr>" "")
          (key "n" "t" "<cmd>BufferLineSortByTabs<cr>" "")
        ])
      );
    plugins.bufferline = {
      enable = true;
      settings.options = {
        diagnostics = "nvim_lsp";
        truncate_names = true;
        offsets = [
          {
            filetype = "neo-tree";
            text = "Neo-tree";
            highlight = "Directory";
            text_align = "left";
          }
        ];
        mode = "buffers";
        close_icon = " ";
        buffer_close_icon = "󰱝 ";
        modified_icon = "󰔯 ";
      };
    };
  };
}
