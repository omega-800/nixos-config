{ sys, options, config, lib, ... }:
let
  langs = config.u.user.nixvim.langSupport;
  inherit (lib) mkMerge mkIf;
  inherit (builtins) elem;
in
{
  imports = [ ./treesitter.nix ./none-ls.nix ./typescript.nix ];
  programs.nixvim = mkMerge [
    {
      keymaps = [
        {
          mode = "n";
          key = "<leader>g";
          action = "+goto";
        }
        # Trouble 
        {
          mode = "n";
          key = "<leader>d";
          action = "+diagnostics/debug";
        }
        {
          key = "<leader>dt";
          action = "<CMD>TroubleToggle<CR>";
          options.desc = "Toggle trouble";
        }
        # lsp
        {
          mode = "n";
          key = "<leader>l";
          action = "+lsp";
        }
      ];
      plugins = {
        lsp = {
          enable = true;
          servers = mkMerge [
            {
              typos-lsp = {
                enable = true;
                # TODO: fix this
                autostart = false;
              };
            }
            (mkIf (elem "js" langs) {
              volar.enable = true;
              jsonls.enable = true;
            })
            (mkIf (elem "md" langs) { marksman.enable = true; })
            (mkIf (elem "nix" langs) {
              nixd = {
                enable = true;
                # cmd = [ "nixfmt" ];
                # extraOptions = options;
              };
            })
            (mkIf (elem "sh" langs) { bashls.enable = true; })
            (mkIf (elem "sh" langs) { bashls.enable = true; })
            (mkIf (elem "html" langs) {
              html.enable = true;
              htmx.enable = true;
            })
            (mkIf (elem "css" langs) {
              cssls.enable = true;
              tailwindcss.enable = true;
            })
            (mkIf (elem "c" langs) {
              clangd.enable = true;
              cmake.enable = true;
            })
            (mkIf (elem "gql" langs) { graphql.enable = true; })
            (mkIf (elem "docker" langs) { dockerls.enable = true; })
            (mkIf (elem "yaml" langs) {
              yamlls.enable = true;
              docker_compose_language_service.enable = true;
              ansiblels.enable = true;
            })
            (mkIf (elem "sql" langs) { sqls.enable = true; })
            (mkIf (elem "lua" langs) { lua-ls.enable = true; })
            (mkIf (elem "python" langs) { pylsp.enable = true; })
            (mkIf (elem "go" langs) { gopls.enable = true; })
            (mkIf (elem "java" langs) { java_language_server.enable = true; })
          ];
          keymaps = {
            diagnostic = {
              "<leader>ln" = "goto_next";
              "<leader>lp" = "goto_prev";
            };
            lspBuf = {
              "K" = "hover";
              "gd" = "definition";
              "gD" = "declaration";
              "gr" = "references";
              "gI" = "implementation";
              "gy" = "type_definition";
            };
            extra = [
              #nprstx
              {
                action = "<CMD>lua vim.lsp.buf.signature_help()<CR>";
                key = "<leader>lh";
                options.desc = "Signature help";
              }
              {
                action = "<CMD>lua vim.lsp.buf.document_symbol()<CR>";
                key = "<leader>ld";
                options.desc = "Document symbol";
              }
              {
                action = "<CMD>lua vim.lsp.buf.rename()<CR>";
                key = "<leader>lc";
                options.desc = "Change/rename";
              }
              {
                action = "<CMD>lua vim.lsp.buf.format()<CR>";
                key = "<leader>lf";
                options.desc = "Format";
              }
              {
                action = "<CMD>lua vim.lsp.buf.code_action()<CR>";
                key = "<leader>la";
                options.desc = "Action/quickfix";
              }
              {
                action = "<CMD>LspInfo<Enter>";
                key = "<leader>li";
              }
              {
                action = "<CMD>LspStop<Enter>";
                key = "<leader>lx";
              }
              {
                action = "<CMD>LspStart<Enter>";
                key = "<leader>ls";
              }
              {
                action = "<CMD>LspRestart<Enter>";
                key = "<leader>lr";
              }
            ];
          };
        };
        lsp-lines.enable = true;
        lsp-format.enable = true;
        trouble.enable = true;
      };
    }
    (if sys.stable then {
      plugins.lsp-lines.currentLine = true;
    } else {
      diagnostics.virtual_lines.only_current_line = true;
    })
  ];
}
