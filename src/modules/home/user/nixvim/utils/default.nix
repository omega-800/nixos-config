{
  globals,
  lib,
  sys,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib.omega.vim) keyG key keyS;
in
{
  imports = [
    ./keymaps.nix
    ./oil.nix
    ./vimwiki.nix
    #./firenvim.nix
  ];
  programs.nixvim = {
    keymaps =
      (keyG "<leader>h" "harpoon" [ ])
      ++ (keyG "<leader>u" "undo" [
        (keyS "n" "t" "<cmd>UndotreeToggle<CR>" "Undotree")
      ])
      ++ (keyG "<leader>f" "find/file" [
        (key "n" "F" "<cmd>Telescope find_files hidden=true<cr>" "Find files Hidden Also")
        (key "n" "d" "<cmd>Telescope diagnostics theme=ivy<cr>" "Search Diagnostics")
        (key "n" "n" "<cmd>Telescope notify<cr>" "Notifications Search")
        (key "n" "k" "<cmd>Telescope keymaps theme=dropdown<cr>" "Search Keymaps")
        (key "n" "s" "<cmd>Telescope builtin<cr>" "Search Telescope")
        (key "n" "g" "<cmd>Telescope live_grep<cr>" "Search Live Grep")
        (key "n" "H" "<cmd>Telescope help_tags<cr>" "Search Help Tags")
        (key "n" "b" "<cmd>Telescope buffers<cr>" "Search Buffers")
        (key "n" "c" "<cmd>Telescope commands<cr>" "Search Commands")
        (key "n" "m" "<cmd>Telescope marks<cr>" "Search in Media Mode")
        (key "n" "o" "<cmd>Telescope vim_options<cr>" "Search Vim Options")
        (key "n" "q" "<cmd>Telescope quickfix<cr>" "Search Quickfix")
        (key "n" "l" "<cmd>Telescope loclist<cr>" "Search Location List")
        (key "n" "p" "<cmd>Telescope projects<cr>" "Search Projects")
        (key "n" "P" "<cmd>Telescope colorscheme<cr>" "Search ColorScheme with previews")
        (key "n" "u" "<cmd>Telescope undo<cr>" "Search undo")
        (key "n" "/" "<cmd>Telescope current_buffer_fuzzy_find<cr>" "Fuzzy Buffer Search")
        (key "n" "t" "<CMD>TodoTelescope<CR>" "Search TODO's")
      ])
      ++ [
        (key "t" "<esc>" "<C-\\><C-n>" "Escape terminal mode")
        (key "n" "<leader>go" "<cmd>Telescope git_status<cr>" "Open changed file")
        (key "n" "<leader>gb" "<cmd>Telescope git_branches<cr>" "Checkout branch")
        (key "n" "<leader>gc" "<cmd>Telescope git_commits<cr>" "Checkout commit")
        {
          mode = "n";
          key = "<leader>ha";
          action.__raw = "function() require'harpoon':list():add() end";
        }
        {
          mode = "n";
          key = "<leader>hh";
          action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
        }
        {
          mode = "n";
          key = "<C-j>";
          action.__raw = "function() require'harpoon':list():select(1) end";
        }
        {
          mode = "n";
          key = "<C-k>";
          action.__raw = "function() require'harpoon':list():select(2) end";
        }
        {
          mode = "n";
          key = "<C-l>";
          action.__raw = "function() require'harpoon':list():select(3) end";
        }
        {
          mode = "n";
          key = "<C-m>";
          action.__raw = "function() require'harpoon':list():select(4) end";
        }
      ];
    plugins = {
      # codesnap = {
      #   enable = true;
      #   settings = {
      #     breadcrumbs_separator = "/";
      #     has_breadcrumbs = true;
      #     has_line_number = true;
      #     mac_window_bar = true;
      #     show_workspace = true;
      #     save_path = globals.envVars.SCREENSHOTS_DIR;
      #     title = "CodeSnap.nvim";
      #     code_font_family = usr.font;
      #     watermark_font_family = usr.font;
      #     watermark = "";
      #   };
      # };
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
          pickers = {
            colorscheme.enable_preview = true;
          };
          defaults.mappings = {
            n = {
              q = {
                __raw = "require('telescope.actions').close";
              };
              s = {
                __raw = "require('telescope.actions').select_horizontal";
              };
              v = {
                __raw = "require('telescope.actions').select_vertical";
              };
            };
          };
        };
      };
      harpoon = {
        enable = true;
        enableTelescope = true;
      };
      fidget = {
        enable = true;
        settings.progress = {
          suppress_on_insert = true;
          ignore_done_already = true;
          poll_rate = 1;
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
        settings = {
          keymaps_toggle = "<leader>,";
          width = 0.8;
          height = 0.8;
          title = "";
        };
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
        filetypesDenylist = [
          "Outline"
          "TelescopePrompt"
          "alpha"
          "harpoon"
          "reason"
        ];
      };
      which-key = lib.mkMerge [
        { enable = true; }
        (
          if sys.stable then
            { }
          else
            {
              settings = {
                ignoreMissing = false;
                icons = {
                  breadcrumb = "»";
                  group = "+";
                  separator = ""; # ➜
                };
                # registrations = {
                #   "<leader>t" = " Terminal";
                # };
                win = {
                  border = "none";
                  wo.winblend = 0;
                };
              };
            }
        )
      ];
      /*
        hardtime = lib.mkIf (!sys.stable) {
          enable = false;
          settings = {
            enabled = false;
            disableMouse = true;
            disabledFiletypes = [ "Oil" ];
            hint = true;
            maxCount = 4;
            maxTime = 1000;
            restrictionMode = "hint";
            restrictedKeys = {
              "h" = [ "n" "x" ];
              "j" = [ "n" "x" ];
              "k" = [ "n" "x" ];
              "l" = [ "n" "x" ];
              "-" = [ "n" "x" ];
              "+" = [ "n" "x" ];
              "gj" = [ "n" "x" ];
              "gk" = [ "n" "x" ];
              "<CR>" = [ "n" "x" ];
              "<C-M>" = [ "n" "x" ];
              "<C-N>" = [ "n" "x" ];
              "<C-P>" = [ "n" "x" ];
            };
          };
        };
      */
    };
  };
}
