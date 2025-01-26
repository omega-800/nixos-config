{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkBefore;
  inherit (builtins) elem;
  enabled = elem "c" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        clangd.enable = true;
        cmake.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        diagnostics = {
          cppcheck.enable = true;
          checkmake.enable = true;
        };
        formatting = {
          clang_format.enable = true;
          cmake_format.enable = true;
        };
      };
    };
    # dap
    # extraPlugins = [ pkgs.vimPlugins.nvim-gdb ];
    extraConfigLua = ''
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
    '';
  };
}
