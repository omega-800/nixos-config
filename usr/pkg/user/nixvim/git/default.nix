{
  programs.nixvim = {
    keymaps = [
      # Git    
      {
        mode = "n";
        key = "<leader>g";
        action = "+git";
      }
      {
        mode = "n";
        key = "<leader>gt";
        action = "+toggles";
      }
      {
        key = "<leader>gtb";
        action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
        options.desc = "Gitsigns current line blame";
      }
      {
        key = "<leader>gtd";
        action = "<CMD>Gitsigns toggle_deleted";
        options.desc = "Gitsigns deleted";
      }
      {
        key = "<leader>gd";
        action = "<CMD>Gitsigns diffthis<CR>";
        options.desc = "Gitsigns diff this buffer";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "+resets";
      }
      {
        key = "<leader>grh";
        action = "<CMD>Gitsigns reset_hunk<CR>";
        options.desc = "Gitsigns reset hunk";
      }
      {
        key = "<leader>grb";
        action = "<CMD>Gitsigns reset_buffer<CR>";
        options.desc = "Gitsigns reset current buffer";
      }
    ];
    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          trouble = true;
          signs = {
            add = { text = " "; };
            change = { text = " "; };
            delete = { text = " "; };
            untracked = { text = ""; };
            topdelete = { text = "󱂥 "; };
            changedelete = { text = "󱂧 "; };
          };
        };
      };
    };
  };
}
