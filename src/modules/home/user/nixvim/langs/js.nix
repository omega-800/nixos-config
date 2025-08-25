{
  config,
  lib,
  pkgs,
  sys,
  ...
}:
let
  inherit (lib) mkIf mkBefore genAttrs;
  inherit (sys) system;
  inherit (lib.omega.vim) keyG key keyS;
  inherit (builtins) elem;
  inherit (config.programs.nixvim) plugins;

  enabled = elem "js" config.u.user.nixvim.langSupport;

  /*
    nodejs = pkgs.nodejs_20;
    src = pkgs.fetchFromGitHub {
      owner = "relief-melone";
      repo = "vscode-js-debug";
      rev = "feature.v1.100.0-vimPlugin";
      sha256 = "sha256-CeAAzwPUiRyjsAiLCUb0fcyAvbJWaPgeKNAdYfTf4+c=";

    };

    nodePkgs = import "${src}/default.nix" { inherit pkgs system nodejs; };
    inherit ( nodePkgs // { inherit pkgs; }) nodeDependencies;

    vscode-js-debug = pkgs.vimUtils.buildVimPlugin {
      inherit src;

      pname = "vscode-js-debug";
      version = "v1.97.0";

      nativeBuildInputs = [ nodejs ];

      buildPhase = ''
        ln -s ${nodeDependencies}/lib/node_modules ./node_modules

        export PATH="${nodeDependencies}/bin:$PATH"
        export XDG_CACHE_HOME=$(pwd)/node-gyp-cache

        npx gulp dapDebugServer

        mv ./dist out
      '';
    };
    nvim-dap-vscode-js = pkgs.vimUtils.buildVimPlugin {
      name = "nvim-dap-vscode-js";
      src = pkgs.fetchFromGitHub {
        owner = "mxsdev";
        repo = "nvim-dap-vscode-js";
        rev = "v1.1.0";
        sha256 = "sha256-lZABpKpztX3NpuN4Y4+E8bvJZVV5ka7h8x9vL4r9Pjk=";
      };
      dependencies = [
        vscode-js-debug
        pkgs.vimPlugins.nvim-dap
      ];
    };
  */

  filetypes = [
    "javascript"
    "javascriptreact"
    "typescript"
    "typescriptreact"
  ];
in
{
  # TODO: split this up into js/ts/json?
  config.programs.nixvim = mkIf enabled {
    keymaps =
      (keyG "<leader>lt" "typescript" [
        (key "n" "o" "<cmd>TSToolsOrganizeImports<cr>" "Organize imports")
        (key "n" "r" "<cmd>TSToolsRemoveUnusedImports<cr>" "Remove unused imports")
        (key "n" "s" "<cmd>TSToolsSortImports<cr>" "Sort imports")
        (key "n" "d" "<cmd>TSToolsGoToSourceDefinition<cr>" "Go to source definition")
        (key "n" "q" "<cmd>TSToolsRemoveUnused<cr>" "Remove unused")
        (key "n" "m" "<cmd>TSToolsAddMissingImports<cr>" "Add missing imports")
        (key "n" "a" "<cmd>TSToolsFixAll<cr>" "Fix all")
        (key "n" "n" "<cmd>TSToolsRenameFile<cr>" "Rename file")
        (key "n" "f" "<cmd>TSToolsFileReferences<cr>" "File references")
      ])
      ++ (keyG "<leader>j" "javascript" [
        (key "n" "b" "<CMD>!npm run build<CR>" "Build npm project")
        (key "n" "r" "<CMD>!npm run run<CR>" "Run npm project")
        (key "n" "d" "<CMD>!npm run dev<CR>" "Watch npm project")
        (key "n" "l" "yiwoconsole.log('<esc>pa', <esc>pa);<esc>" "console.log")
        (key "v" "l" "yoconsole.log('<esc>pa', <esc>pa);<esc>" "console.log")
      ]);
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        # volar.enable = true;
        jsonls.enable = true;
        ts_ls = {
          inherit filetypes;
          enable = true;
          autostart = true;
          extraOptions = {
            settings =
              let
                cfg = {
                  inlayHints = {
                    includeInlayEnumMemberValueHints = false;
                    includeInlayFunctionLikeReturnTypeHints = false;
                    includeInlayFunctionParameterTypeHints = false;
                    # includeInlayParameterNameHints = "all";
                    includeInlayParameterNameHints = "none";
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false;
                    includeInlayPropertyDeclarationTypeHints = false;
                    includeInlayVariableTypeHints = false;
                    includeInlayVariableTypeHintsWhenTypeMatchesName = false;
                  };
                };
              in
              genAttrs filetypes (_: cfg);
          };
        };
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting.biome.enable = false;
      };
      dap = {
        adapters = {
          executables = {
            pwa-node = "node";
            node = "node";
          };
          servers =
            let
              cfg = {
                host = "localhost";
                port = ''''${port}'';
                executable = {
                  command = "${pkgs.vscode-js-debug}/bin/js-debug";
                  args = [ ''''${port}'' ];
                };
              };
            in
            {
              pwa-node = cfg;
              node = cfg;
            };
        };
        configurations =
          let
            cfg = [
              {
                type = "pwa-node";
                request = "launch";
                name = "Launch file";
                program = "\${file}";
                cwd = "\${workspaceFolder}";
              }
              {
                type = "pwa-node";
                request = "attach";
                name = "Attach";
                processId.__raw = "require 'dap.utils'.pick_process";
                cwd = ''''${workspaceFolder}'';
              }
            ];
          in
          genAttrs filetypes (_: cfg);
      };
      typescript-tools = {
        enable = false;
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
          # FIXME: shouldn't be necessary?
          tsserver_file_preferences = {
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
          settings = {
            complete_function_calls = true;
            expose_as_code_action = "all";
          };
        };
      };
    };
    # extraPlugins = [ nvim-dap-vscode-js ];
    extraPlugins = with pkgs.vimPlugins; [ nvim-dap-vscode-js ];
    extraConfigLua = ''
      local dap_vscode_js = require("dap-vscode-js")
      dap_vscode_js.setup({
        debugger_path = "${pkgs.vscode-js-debug}",
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node' }
      })
    '';
    /*
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
