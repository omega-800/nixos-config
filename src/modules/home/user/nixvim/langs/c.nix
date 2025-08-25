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
          # eats up cpu?
          # cppcheck.enable = true;
          checkmake.enable = true;
        };
        formatting = {
          clang_format.enable = true;
          cmake_format.enable = true;
        };
      };
      dap = {
        adapters = {
          executables = {
            lldb.command = lib.getExe' pkgs.lldb "lldb-vscode";
            gdb = {
              command = "gdb";
              args = [
                "-i"
                "dap"
              ];
            };
          };
          servers.codelldb = {
            port = 13000;
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [
                "--port"
                "13000"
              ];
            };
          };
        };
        # TODO: https://discourse.nixos.org/t/how-to-correctly-use-dap-lldb-for-nixvim/58196
        configurations =
          let
            mkCfg = type: {
              inherit type;
              name = "launch (${type})";
              request = "launch";
              program.__raw = ''
                function()
                		return vim.fn.input('Path of the executable: ', vim.fn.getcwd() .. '/', 'file')
                end
              '';
              cwd = ''''${workspaceFolder}'';
            };
            gdb = mkCfg "gdb";
            lldb = mkCfg "lldb";
            codelldb = mkCfg "codelldb";
          in
          {
            c = [
              gdb
              lldb
            ];
            cpp = [
              gdb
              lldb
              codelldb
            ];
            # TODO: move to rust config
            rust = [
              gdb
              lldb
              codelldb
            ];
          };
      };
    };
    # dap
    # extraPlugins = [ pkgs.vimPlugins.nvim-gdb ];
    /*
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
    */
  };
}
