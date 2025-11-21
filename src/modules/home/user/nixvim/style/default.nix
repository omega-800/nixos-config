{
  lib,
  ...
}:
let
  inherit (lib.omega.vim) keyG key;
in
{
  imports = [
    ./lualine.nix
    ./startup.nix
    ./bufferline.nix
  ];
  programs.nixvim = {
    keymaps =
      [
        (key "n" "<Tab>" "<CMD>tabnext<CR>" "Go to the next tab")
        (key "n" "<S-Tab>" "<CMD>tabprevious<CR>" "Go to the previous tab")
      ]
      ++ (keyG "<leader>t" "tab" [
        (key "n" "t" "<CMD>tabnew<CR>" "Create new tab")
        (key "n" "d" "<CMD>tabclose<CR>" "Close tab")
        (key "n" "n" "<CMD>tabnext<CR>" "Go to the next tab")
        (key "n" "p" "<CMD>tabprevious<CR>" "Go to the previous tab")
      ]);
    plugins = {
      todo-comments.enable = true;
      rainbow-delimiters.enable = true;
      nvim-autopairs = {
        enable = true;
        settings = {
          fast_wrap = { };
          disable_filetype = [
            "TelescopePrompt"
            "vim"
          ];
        };
      };
      colorizer = {
        enable = true;
        #FIXME: update
        #userDefaultOptions = {
        #  RGB = true;
        #  RRGGBB = true;
        #  names = true;
        #  RRGGBBAA = true;
        #  AARRGGBB = true;
        #  rgb_fn = true;
        #  hsl_fn = true;
        #  css = true;
        #  css_fn = true;
        #  mode = "background";
        #  tailwind = true;
        #  sass = {
        #    enable = true;
        #  };
        #  virtualtext = "■";
        #};
      };
      wilder = {
        enable = false;
        settings = {
          modes = [
            ":"
            "/"
            "?"
          ];
          enable_cmdline_enter = true;
          accept_completion_auto_select = true;
        };
      };
    };
  };
}
