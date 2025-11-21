{
  lib,
  sys,
  ...
}:
let
  inherit (lib.omega.vim) keyG key keyS;
in
{
  # TODO: treesj, mini.surround, tabout.nvim
  imports = [
    ./keymaps.nix
    ./oil.nix
    ./vimwiki.nix
    ./telescope.nix
    #./firenvim.nix
  ];
  programs.nixvim = {
    keymaps =
      (keyG "<leader>h" "harpoon" [ ])
      ++ (keyG "<leader>u" "undo" [
        (keyS "n" "t" "<cmd>UndotreeToggle<CR>" "Undotree")
      ])
      ++ [
        (key "t" "<esc>" "<C-\\><C-n>" "Escape terminal mode")
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
        settings = {
          under_cursor = false;
          filetypes_denylist = [
            "Outline"
            "TelescopePrompt"
            "alpha"
            "harpoon"
            "reason"
          ];
        };
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
      harpoon = {
        enable = false;
        enableTelescope = true;
      };
      floaterm = {
        enable = false;
        settings = {
          keymaps_toggle = "<leader>,";
          width = 0.8;
          height = 0.8;
          title = "";
        };
      };
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
