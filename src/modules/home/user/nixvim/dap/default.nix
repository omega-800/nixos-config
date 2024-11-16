{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<leader>d";
        action = "+diagnostics/debug";
      }
      {
        mode = "n";
        key = "<leader>dx";
        action = "<cmd>DapTerminate<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dr";
        action = ''<cmd>lua require("dap").run_to_cursor()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "v";
        key = "<leader>dw";
        action = ''<cmd>lua require("dapui").eval(vim.fn.expand("<cword>"))<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>de";
        action = ''<cmd>lua require("dapui").eval()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>DapToggleBreakpoint<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>DapContinue<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dn";
        action = "<cmd>DapStepOver<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>DapStepOver<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>di";
        action = "<cmd>DapStepInto<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dp";
        action = ''<cmd>lua require("dap").pause()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>d<Down>"; # <A-F8>
        action = ''<cmd>lua require("dap").down()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>d<Up>"; # <A-F9>
        action = ''<cmd>lua require("dap").up()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>df";
        action = ''<cmd>lua require("dap").focus_frame()<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dc"; # <A-F9>
        action = ''<cmd>lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition:"))<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>du";
        action = ''<cmd>lua require("dapui").toggle(1)<cr><cmd>lua require("dapui").toggle(2)<cr>'';
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dv";
        action = "+virtual-text";
      }
      {
        mode = "n";
        key = "<leader>dvt";
        action = "<cmd>DapVirtualTextToggle<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dve";
        action = "<cmd>DapVirtualTextEnable<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dvd";
        action = "<cmd>DapVirtualTextDisable<cr>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>dvr";
        action = "<cmd>DapVirtualTextForceRefresh<cr>";
        options = {
          silent = true;
        };
      }
    ];
    plugins.dap = {
      enable = true;
      extensions = {
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };
    extraConfigLua =
      # lua
      ''
        -- TODO: this line should come before the lang-specific code
        local dap, dapui = require("dap"), require("dapui")


        -- DEBUG LISTENERS
        dap.listeners.before.attach.dapui_config = function()
           	dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
           	dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
           	dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
           	dapui.close()
        end

        local dap = require('dap')
        dap.set_log_level('DEBUG')
      '';
  };
}
