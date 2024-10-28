{ lib, config, ... }:
{
  programs.nixvim = lib.mkIf (lib.elem "js" config.u.user.nixvim.langSupport) {
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
    plugins.typescript-tools = {
      enable = true;
      settings = {
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
}
