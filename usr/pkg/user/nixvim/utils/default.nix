{
  imports = [ 
  ./keymaps.nix 
#./firenvim.nix 
  ];
  programs.nixvim = {
    keymaps = [
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
      # telescope
      # file
      {
        mode = "n";
        key = "<leader>f";
        action = "+find/file";
      }
      {
        mode = "n";
        key = "<leader>fF";
        action = "<cmd>Telescope find_files hidden=true<cr>";
        options.desc = "Find files Hidden Also";
      }
      {
        mode = "n";
        key = "<leader>go";
        action = "<cmd>Telescope git_status<cr>";
        options.desc = "Open changed file";
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Telescope git_branches<cr>";
        options.desc = "Checkout branch";
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = "<cmd>Telescope git_commits<cr>";
        options.desc = "Checkout commit";
      }

      {
        mode = "n";
        key = "<leader>sd";
        action = "<cmd>Telescope diagnostics theme=ivy<cr>";
        options.desc = "Search Diagnostics";
      }
      {
        mode = "n";
        key = "<leader>sn";
        action = "<cmd>Telescope notify<cr>";
        options.desc = "Notifications Search";
      }
      {
        mode = "n";
        key = "<leader>sk";
        action = "<cmd>Telescope keymaps theme=dropdown<cr>";
        options.desc = "Search Keymaps";
      }
      {
        mode = "n";
        key = "<leader>ss";
        action = "<cmd>Telescope builtin<cr>";
        options.desc = "Search Telescope";
      }
      {
        mode = "n";
        key = "<leader>sg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Search Live Grep";
      }
      {
        mode = "n";
        key = "<leader>sH";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Search Help Tags";
      }
      {
        mode = "n";
        key = "<leader>sb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Search Buffers";
      }
      {
        mode = "n";
        key = "<leader>sc";
        action = "<cmd>Telescope commands<cr>";
        options.desc = "Search Commands";
      }
      {
        mode = "n";
        key = "<leader>sm";
        action = "<cmd>Telescope marks<cr>";
        options.desc = "Search in Media Mode";
      }
      {
        mode = "n";
        key = "<leader>so";
        action = "<cmd>Telescope vim_options<cr>";
        options.desc = "Search Vim Options";
      }
      {
        mode = "n";
        key = "<leader>sq";
        action = "<cmd>Telescope quickfix<cr>";
        options.desc = "Search Quickfix";
      }
      {
        mode = "n";
        key = "<leader>sl";
        action = "<cmd>Telescope loclist<cr>";
        options.desc = "Search Location List";
      }
      {
        mode = "n";
        key = "<leader>sp";
        action = "<cmd>Telescope projects<cr>";
        options.desc = "Search Projects";
      }
      {
        mode = "n";
        key = "<leader>sP";
        action = "<cmd>Telescope colorscheme<cr>";
        options.desc = "Search ColorScheme with previews";
      }
      {
        mode = "n";
        key = "<leader>su";
        action = "<cmd>Telescope undo<cr>";
        options.desc = "Search undo";
      }
      {
        mode = "n";
        key = "<leader>s/";
        action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
        options.desc = "Fuzzy Buffer Search";
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
        extensions = {
          fzf-native.enable = true;
          undo.enable = true;
        };
        settings = {
          pickers = { colorscheme.enable_preview = true; };
          defaults.mappings = {
            n = {
              q = { __raw = "require('telescope.actions').close"; };
              s = { __raw = "require('telescope.actions').select_horizontal"; };
              v = { __raw = "require('telescope.actions').select_vertical"; };
            };
          };
        };
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
