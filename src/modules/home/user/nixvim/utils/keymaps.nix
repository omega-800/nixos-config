{ lib, ... }:
let
  inherit (lib.omega.vim) keyG key;
in
{
  programs.nixvim = {
    keymaps =
      [
        (key "n" "M" ":Man <C-R>=expand(\"<cword>\")<cr><cr>" "Open manpage")
        (key "n" "<leader>q" "<cmd>confirm q<cr>" "Quit window")
        (key "n" "<leader>Q" "<cmd>confirm qall<cr>" "Exit vim")
        (key "n" "<leader>n" "<cmd>enew<cr>" "New file")
        (key "n" "<c-s>" "<cmd>silent! update! | redraw<cr>" "Force write")
        (key [ "i" "x" ] "<c-s>" "<esc><cmd>silent! update! | redraw<cr>" "Force write")
        (key "n" "<c-q>" "<cmd>q!<cr>" "Force quit")
        (key "v" "<S-Tab>" "<gv" "Unindent line")
        (key "v" "<Tab>" ">gv" "Indent line")
        (key "n" "<C-Up>" "<Cmd>resize -1<CR>" "Resize split up")
        # Windows
        (key "n" "<C-Down>" "<Cmd>resize +1<CR>" "Resize split down")
        (key "n" "<C-Left>" "<Cmd>vertical resize -2<CR>" "Resize split left")
        (key "n" "<C-Right>" "<Cmd>vertical resize +2<CR>" "Resize split right")
        # moving line
        # (key "v" "<M-k>" ":m '<lt>-2<CR>gv-gv" "")
        # (key "v" "<M-j>" ":m '>+1<CR>gv-gv" "")
        # (key "n" "<M-k>" "<Cmd>m .-2<CR>==" "")
        # (key "n" "<M-j>" "<Cmd>m .+1<CR>==" "")
        # (key "i" "<M-k>" "<esc>:m .-2<CR>==gi" "")
        # (key "i" "<M-j>" "<esc>:m .+1<CR>==gi" "")
      ]
      ++ (keyG "<leader>w" "window/wrap" [
        (key "n" "v" "<Cmd>vsplit<CR>" "Vertical split")
        (key "n" "h" "<Cmd>split<CR>" "Horizontal split")
      ])
      ++ (keyG "<leader>v" "visual" [
        (key "n" "a" "gg0vG$" "Select all")
        (key "n" "c" "<Cmd>nohls<CR>" "Clear highlight")
      ]);
    /*
      extraPlugins = with pkgs.vimUtils;
        [
          (buildVimPlugin {
            pname = "precognition.nvim";
            version = "v1.0.0";
            src = pkgs.fetchFromGitHub {
              owner = "tris203";
              repo = "precognition.nvim";
              rev = "5255b72c52b1159e9757f50389bde65e05e3bfb1";
              hash = "sha256-AqWYV/59ugKyOWALOCdycWVm0bZ7qb981xnuw/mAVzM=";
            };
          })
        ];
      extraConfigLua = ''
        require('precognition').setup({ })
      '';
    */
  };
}
