{
  sys,
  lib,
  ...
}:
let
  inherit (lib) mkMerge;
  inherit (lib.omega.vim) keyG key;
in
{
  imports = [
    ./treesitter.nix
    ./none-ls.nix
  ];
  programs.nixvim = mkMerge [
    {
      keymaps =
        (keyG "<leader>g" "goto" [ ])
        ++ (keyG "<leader>l" "lsp" (
          [
            (key "n" "t" "<CMD>TroubleToggle<CR>" "Toggle trouble")
          ]
          ++ (keyG "e" "inlay_hint" [ ])
        ));
      plugins = {
        lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            typos_lsp = {
              enable = true;
              # TODO: fix this
              autostart = false;
            };
          };
          keymaps = {
            diagnostic = {
              "<leader>ln" = {
                action = "goto_next";
                desc = "Next";
              };
              "<leader>lp" = {
                action = "goto_prev";
                desc = "Previous";
              };
              "<leader>lx" = {
                action = "hide";
                desc = "Hide";
              };
              "<leader>lw" = {
                action = "show";
                desc = "Show";
              };
            };
            lspBuf = {
              "K" = {
                action = "hover";
                desc = "Hover";
              };
              "gd" = {
                action = "definition";
                desc = "Go to definition";
              };
              "gD" = {
                action = "declaration";
                desc = "Go to declaration";
              };
              "gr" = {
                action = "references";
                desc = "Go to references";
              };
              "gI" = {
                action = "implementation";
                desc = "Go to implementation";
              };
              "gy" = {
                action = "type_definition";
                desc = "Go to type definition";
              };
              "gY" = {
                action = "typehierarchy";
                desc = "Display type hierarchy";
              };
              "<leader>lh" = {
                action = "signature_help";
                desc = "Signature help";
              };
              "<leader>ld" = {
                action = "document_symbol";
                desc = "Document symbol";
              };
              "<leader>lc" = {
                action = "rename";
                desc = "Rename/change";
              };
              "<leader>lf" = {
                action = "format";
                desc = "Format";
              };
            };
            extra = [
              {
                action = "<CMD>lua vim.diagnostic.open_float()<CR> <CMD>lua vim.diagnostic.open_float()<CR>";
                key = "<leader>lo";
                options.desc = "Open float";
              }
              {
                action = "<CMD>lua vim.lsp.buf.code_action({apply=true})<CR>";
                key = "<leader>la";
                options.desc = "Action/quickfix";
              }
              {
                action = "<CMD>lua vim.lsp.inlay_hint.enable(true)<CR>";
                key = "<leader>les";
                options.desc = "Enable";
              }
              {
                action = "<CMD>lua vim.lsp.inlay_hint.enable(false)<CR>";
                key = "<leader>leq";
                options.desc = "Disable";
              }
              {
                action = "<CMD>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>";
                key = "<leader>let";
                options.desc = "Toggle";
              }
              {
                action = "<CMD>LspInfo<Enter>";
                key = "<leader>li";
              }
              {
                action = "<CMD>LspStop<Enter>";
                key = "<leader>lq";
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
          #          onAttach = ''
          #             vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          #               group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          #               callback = function(args)
          #                 local client = vim.lsp.get_client_by_id(args.data.client_id)
          #                 if client.supports_method('textDocument/documentHighlight') then
          #                   vim.lsp.buf.document_highlight()
          #                 end
          #               end
          #             })
          #
          #             vim.api.nvim_create_autocmd("CursorMoved", {
          #               callback = function(args)
          #
          #                 local client = vim.lsp.get_client_by_id(args.data.client_id)
          #                 if client.supports_method('textDocument/documentHighlight') then
          #                   vim.lsp.buf.clear_references()
          #                 end
          #               end
          #             })
          #          '';
        };
        # lsp-lines.enable = true;
        # lsp-format.enable = true;
        # lsp-signature.enable = true;
        trouble.enable = true;
      };
    }
    (
      if sys.stable then
        {
          plugins.lsp-lines.currentLine = true;
        }
      else
        {
          diagnostics.virtual_lines.only_current_line = true;
        }
    )
  ];
}
