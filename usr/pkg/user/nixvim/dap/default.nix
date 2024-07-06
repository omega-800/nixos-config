{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>dx"; # "<C-F11>"
        action = ''<cmd>lua require("dap").terminate()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = ''<cmd>lua require("dap").run_to_cursor()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "v";
        key = "<leader>dw";
        action =
          ''<cmd>lua require("dapui").eval(vim.fn.expand("<cword>"))<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>de";
        action = ''<cmd>lua require("dapui").eval()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>db";
        action = ''<cmd>lua require("dap").toggle_breakpoint()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = ''<cmd>lua require("dap").continue()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>dn";
        action = ''<cmd>lua require("dap").step_over()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>do";
        action = ''<cmd>lua require("dap").step_out()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>di";
        action = ''<cmd>lua require("dap").step_into()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>dp";
        action = ''<cmd>lua require("dap").pause()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>d<Down>"; # <A-F8>
        action = ''<cmd>lua require("dap").down()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>d<Up>"; # <A-F9>
        action = ''<cmd>lua require("dap").up()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>df";
        action = ''<cmd>lua require("dap").focus_frame()<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>dc"; # <A-F9>
        action = ''
          <cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition:"))<cr>'';
        options = { silent = true; };
      }
      {
        mode = "n";
        key = "<leader>du";
        action = ''
          <cmd>lua require("dapui").toggle(1)<cr><cmd>lua require("dapui").toggle(2)<cr>'';
        options = { silent = true; };
      }
    ];
    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
        dap-go.enable = true;
        dap-python.enable = true;
      };
      adapters = { };
    };
  };
}
