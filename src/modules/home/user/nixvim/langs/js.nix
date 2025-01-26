{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkBefore;
  inherit (builtins) elem;
  enabled = elem "js" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
  nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
    name = "vim-dap-vscode-js";
    src = pkgs.fetchFromGitHub {
      owner = "mxsdev";
      repo = "nvim-dap-vscode-js";
      rev = "e7c05495934a658c8aa10afd995dacd796f76091";
      sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
    };
  };
in
{
  # TODO: split this up into js/ts/json?
  config.programs.nixvim = mkIf enabled {
    keymaps = [
      {
        mode = "n";
        key = "<leader>lt";
        action = "+typescript";
      }
      {
        mode = "n";
        key = "<leader>lto";
        action = "<cmd>TSToolsOrganizeImports<cr>";
        options = {
          desc = "Organize Imports";
        };
      }
      {
        mode = "n";
        key = "<leader>ltr";
        action = "<cmd>TSToolsRemoveUnusedImports<cr>";
        options = {
          desc = "Remove Unused Imports";
        };
      }
    ];
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        volar.enable = true;
        jsonls.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.biome.enable = true;
      };
      /*
        dap = {
          adapters = {
            executables.pwa-node = "node";
            servers.pwa-node = { };
          };
          configurations = {
            typescript = [
              {
                type = "pwa-node";
                request = "launch";
                name = "Launch file";
                program = "\${file}";
                cwd = "\${workspaceFolder}";
              }
            ];
            javascript = [
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
      */
      typescript-tools = {
        enable = true;
        settings = {
          /*
            on_attach = # lua
              ''
                function(client, bufnr)
                  client.server_capabilities.documentFormattingProvider = false
                  client.server_capabilities.documentRangeFormattingProvider = false

                  if vim.lsp.inlay_hint then
                    vim.lsp.inlay_hint(bufnr, true)
                  end
                end
              '';
          */
          tsserver_file_preferences = {
            # Inlay Hints
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
        };
      };
    };
    /*
      extraPlugins = [ nvim-dap-vscode-js ];
      extraConfigLua = ''
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
      '';
    */
  };
}
