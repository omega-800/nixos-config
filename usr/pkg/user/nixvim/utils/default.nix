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
          key = "<leader>w";
          action = "<cmd>w<cr>";
          options.desc = "Save";
        }
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
          mode = [ "i" "x" ];
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
          action = "<Cmd>resize -2<CR>";
          options.desc = "Resize split up";
        }
        {
          mode = "n";
          key = "<C-Down>";
          action = "<Cmd>resize +2<CR>";
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
        # File
        {
          mode = "n";
          key = "<leader>f";
          action = "+find/file";
        }
        # harpoon
        {
          mode = "n";
          key = "<leader>h";
          action = "+harpoon";
        }
        # undo
        {
          mode = "n";
          key = "<leader>u";
          action = "+undo";
        }
        {
          # Escape terminal mode using ESC
          mode = "t";
          key = "<esc>";
          action = "<C-\\><C-n>";
          options.desc = "Escape terminal mode";
        }
        # npm
        {
          mode = "n";
          key = "<leader>j";
          action = "+js";
        }
        {
          mode = "n";
          key = "<leader>jb";
          action = "<CMD>!npm run build<CR>";
          options.desc = "Build npm project";
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
          "<leader>fr" = "live_grep";
          "<leader>ff" = "find_files";
          "<leader>fo" = "oldfiles";
          "<leader>fg" = {
            action = "git_files";
            options.desc = "Telescope Git Files";
          };
        };
        extensions.fzf-native.enable = true;
      };
      harpoon = {
        enable = true;
        enableTelescope = true;
        keymaps = {
          addFile = "<leader>ha";
          toggleQuickMenu = "<leader>hh";
          navFile = {
            "1" = "<C-j>";
            "2" = "<C-k>";
            "3" = "<C-l>";
            "4" = "<C-m>";
          };
        };
      };
      fidget = {
        enable = true;
        progress = {
          suppressOnInsert = true;
          ignoreDoneAlready = true;
          pollRate = 0.5;
        };
      };
      nvim-tree = {
        enable = true;
        openOnSetupFile = true;
        autoReloadOnWrite = true;
      };
      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };
      floaterm = {
        enable = true;
        width = 0.8;
        height = 0.8;
        title = "";
        keymaps.toggle = "<leader>,";
      };
      comment = {
        enable = true;
        settings = {
          opleader.line = "<leader>/";
          toggler.line = "<leader>/";
        };
      };
      tmux-navigator.enable = true;
      # indent-blankline.enable = true;
      illuminate = {
        enable = true;
        underCursor = false;
        filetypesDenylist =
          [ "Outline" "TelescopePrompt" "alpha" "harpoon" "reason" ];
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
    };
  };
}
