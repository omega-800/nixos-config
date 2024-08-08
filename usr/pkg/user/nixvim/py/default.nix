{ usr, ... }: {
  programs.nixvim = {
    plugins = {
      magma-nvim = {
        enable = true;
        settings = {
          automatically_open_output = true;
          cell_highlight_group = "CursorLine";
          image_provider =
            if usr.term == "kitty" then
              "kitty"
            else if usr.term == "alacritty" then
              "ueberzug"
            else
              "none";
          output_window_borders = true;
          save_path = { __raw = "vim.fn.stdpath('data') .. '/magma'"; };
          show_mimetype_debug = false;
          wrap_output = true;
        };
      };
    };
  };
}
