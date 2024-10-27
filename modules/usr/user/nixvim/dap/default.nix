{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins;
let
  nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
    name = "vim-dap-vscode-js";
    src = pkgs.fetchFromGitHub {
      owner = "mxsdev";
      repo = "nvim-dap-vscode-js";
      rev = "e7c05495934a658c8aa10afd995dacd796f76091";
      sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
    };
  };
  langs = config.u.user.nixvim.langSupport;
in
{
  programs.nixvim = {
    keymaps = [
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
      extensions = mkMerge [
        {
          dap-ui.enable = true;
          dap-virtual-text.enable = true;
        }
        (mkIf (elem "go" langs) { dap-go.enable = true; })
        (mkIf (elem "python" langs) { dap-python.enable = true; })
      ];
      adapters = mkIf (elem "js" langs) {
        executables = {
          "pwa-node" = "node";
        };
        servers = {
          "pwa-node" = { };
        };
      };
      configurations = mkIf (elem "js" langs) {
        "typescript" = [
          {
            type = "pwa-node";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            cwd = "\${workspaceFolder}";
          }
        ];
        "javascript" = [
          {
            type = "pwa-node";
            request = "launch";
            name = "Launch file";
            program = "\${file}";
            cwd = "\${workspaceFolder}";
          }
        ];
      };
    };
    extraPlugins =
      (if (elem "js" langs) then [ nvim-dap-vscode-js ] else [ ])
      ++ (if (elem "c" langs) then [ pkgs.vimPlugins.nvim-gdb ] else [ ]);
    extraConfigLua =
      # lua
      ''
        local dap, dapui = require("dap"), require("dapui")
        ${
          if (elem "js" langs) then
            ''
              local dap_vscode_js = require("dap-vscode-js")
              -- DEBUG VS CODE
              dap_vscode_js.setup({
                adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
              })

              -- DEBUG CONFIG TYPESCRIPT
              dap.configurations.typescript = {
                {
                  type = "pwa-node",
                  request = "launch",
                  name = "Launch file",
                  program = "''${file}",
                  cwd = "''${workspaceFolder}",
                },
                {
                  type = "pwa-node",
                  request = "attach",
                  name = "Attach",
                  processId = require'dap.utils'.pick_process,
                  cwd = "''${workspaceFolder}",
                },
                {
                  type = "pwa-node",
                  request = "launch",
                  name = "Run Application",
                  program = "dist/index.js",
                  cwd = "''${workspaceFolder}",
                },
                {
                  type = "pwa-node",
                  request = "launch",
                  name = "Run npm test",
                  program = "node_modules/mocha/bin/_mocha",
                  cwd = "''${workspaceFolder}",
                }
              }
            ''
          else
            ""
        }
        ${
          if (elem "c" langs) then
            ''
                -- DEBUG C
                dap.adapters.lldb = {
                    type = 'executable',
                    command = '${pkgs.lldb_17}/bin/lldb-vscode', -- adjust as needed, must be absolute path
                    name = 'lldb'
                }

                local dap = require("dap")
                dap.adapters.gdb = {
                    type = "executable",
                    command = "gdb",
                    args = { "-i", "dap" }
                }

                local dap = require("dap")
                dap.configurations.c = {
              	{
              		name = "Launch",
              		type = "gdb",
              		request = "launch",
              		program = function()
              			return vim.fn.input('Path of the executable: ', vim.fn.getcwd() .. '/', 'file')
              		end,
              		cwd = "''${workspaceFolder}",
              	},
                }
            ''
          else
            ""
        }

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
