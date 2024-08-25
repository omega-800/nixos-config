{
  imports = [ ./lualine.nix ./startup.nix ./bufferline.nix ];
  programs.nixvim = {
    keymaps = [
      # Tabs
      {
        mode = "n";
        key = "<leader>t";
        action = "+tab";
      }
      {
        mode = "n";
        key = "<leader>tt";
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
        key = "<leader>tn";
        action = "<CMD>tabnext<CR>";
        options.desc = "Go to the next tab";
      }
      {
        mode = "n";
        key = "<leader>tp";
        action = "<CMD>tabprevious<CR>";
        options.desc = "Go to the previous tab";
      }
      {
        mode = "n";
        key = "<Tab>";
        action = "<CMD>tabnext<CR>";
        options.desc = "Go to the next tab";
      }
      {
        mode = "n";
        key = "<S-Tab>";
        action = "<CMD>tabprevious<CR>";
        options.desc = "Go to the previous tab";
      }
      {
        mode = "n";
        key = "<leader>ft";
        action = "<CMD>TodoTelescope<CR>";
      }
    ];
    plugins = {
      todo-comments.enable = true;
      rainbow-delimiters.enable = true;
      nvim-autopairs = {
        enable = true;
        settings = {
          fast_wrap = { };
          disable_filetype = [ "TelescopePrompt" "vim" ];
        };
      };
      nvim-colorizer = {
        enable = true;
        userDefaultOptions = {
          RGB = true;
          RRGGBB = true;
          names = true;
          RRGGBBAA = true;
          AARRGGBB = true;
          rgb_fn = true;
          hsl_fn = true;
          css = true;
          css_fn = true;
          mode = "background";
          tailwind = true;
          sass = { enable = true; }; # fff
          virtualtext = "■";
        };
      };
      wilder = {
        enable = false;
        modes = [ ":" "/" "?" ];
        enableCmdlineEnter = true;
        acceptCompletionAutoSelect = true;
      };
    };
  };
}
