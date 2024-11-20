{ pkgs, ... }:
{
  programs.nixvim = {
    keymaps =
      let
        forceWrite = {
          action = "<cmd>silent! update! | redraw<cr>";
          options.desc = "Force write";
        };
      in
      [
        # Default
        {
          mode = "n";
          key = "<leader>q";
          action = "<cmd>confirm q<cr>";
          options.desc = "Quit window";
        }
        {
          mode = "n";
          key = "<leader>Q";
          action = "<cmd>confirm qall<cr>";
          options.desc = "Exit neovim";
        }
        {
          mode = "n";
          key = "<leader>n";
          action = "<cmd>enew<cr>";
          options.desc = "New file";
        }
        {
          inherit (forceWrite) action options;
          mode = "n";
          key = "<c-s>";
        }
        {
          inherit (forceWrite) options;
          mode = [
            "i"
            "x"
          ];
          key = "<c-s>";
          action = "<esc>" + forceWrite.action;
        }
        {
          mode = "n";
          key = "<c-q>";
          action = "<cmd>q!<cr>";
          options.desc = "Force quit";
        }
        {
          mode = "v";
          key = "<S-Tab>";
          action = "<gv";
          options.desc = "Unindent line";
        }
        {
          mode = "v";
          key = "<Tab>";
          action = ">gv";
          options.desc = "Indent line";
        }
        # Windows
        {
          mode = "n";
          key = "<C-Up>";
          action = "<Cmd>resize -1<CR>";
          options.desc = "Resize split up";
        }
        {
          mode = "n";
          key = "<C-Down>";
          action = "<Cmd>resize +1<CR>";
          options.desc = "Resize split down";
        }
        {
          mode = "n";
          key = "<C-Left>";
          action = "<Cmd>vertical resize -2<CR>";
          options.desc = "Resize split left";
        }
        {
          mode = "n";
          key = "<C-Right>";
          action = "<Cmd>vertical resize +2<CR>";
          options.desc = "Resize split right";
        }
        {
          mode = "n";
          key = "<leader>w";
          action = "+window";
        }
        {
          mode = "n";
          key = "<leader>wv";
          action = "<Cmd>vsplit<CR>";
          options.desc = "Vertical split";
        }
        {
          mode = "n";
          key = "<leader>wh";
          action = "<Cmd>split<CR>";
          options.desc = "Horizontal split";
        }
        {
          mode = "n";
          key = "<leader>v";
          action = "+visual";
        }
        {
          mode = "n";
          key = "<leader>va";
          action = "gg0vG$";
          options.desc = "Select all";
        }
        {
          mode = "n";
          key = "<leader>vc";
          action = "<Cmd>nohls<CR>";
          options.desc = "Clear highlight";
        }
        # moving line
        # {
        #   mode = "v";
        #   key = "<M-k>";
        #   action = ":m '<lt>-2<CR>gv-gv";
        # }
        # {
        #   mode = "v";
        #   key = "<M-j>";
        #   action = ":m '>+1<CR>gv-gv";
        # }
        # {
        #   mode = "n";
        #   key = "<M-k>";
        #   action = "<Cmd>m .-2<CR>==";
        # }
        # {
        #   mode = "n";
        #   key = "<M-j>";
        #   action = "<Cmd>m .+1<CR>==";
        # }
        # {
        #   mode = "i";
        #   key = "<M-k>";
        #   action = "<esc>:m .-2<CR>==gi";
        # }
        # {
        #   mode = "i";
        #   key = "<M-j>";
        #   action = "<esc>:m .+1<CR>==gi";
        # }
      ];
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
