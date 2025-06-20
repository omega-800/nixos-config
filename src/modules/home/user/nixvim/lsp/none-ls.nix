{
  lib,
  sys,
  config,
  ...
}:
let
  inherit (lib)
    mkMerge
    any
    optionalString
    ;
  inherit (builtins) elem;
  langs = config.u.user.nixvim.langSupport;
in
{
  programs.nixvim = {
    plugins.none-ls = mkMerge [
      (
        if sys.stable then
          { }
        else
          {
            # TODO: move this to langs/
            sources.formatting.prettierd = {
              enable = any (l: elem l langs) [
                "js"
                "css"
                "yaml"
                "md"
                "gql"
                "html"
              ];
            disableTsServerFormatter = true;
              settings = # lua
                ''
                  {
                    filetypes = {
                    -- nevermind
                      -- "javascript", -- now done by biome
                      -- "javascriptreact", -- now done by biome
                      -- "typescript", -- now done by biome
                      -- "typescriptreact", -- now done by biome
                      -- "json", -- now done by biome
                      -- "jsonc", -- now done by biome
                    -- nevermind
                      ${optionalString (elem "js" langs) ''
                        "vue",
                      ''}
                      ${optionalString (elem "css" langs) ''
                        "css",
                        "scss",
                        "less",
                      ''}
                      ${optionalString (elem "yaml" langs) ''
                        "yaml",
                      ''}
                      ${optionalString (elem "md" langs) ''
                        "markdown",
                        "markdown.mdx",
                      ''}
                      ${optionalString (elem "gql" langs) ''
                        "graphql",
                      ''}
                      ${optionalString (elem "html" langs) ''
                        "html",
                      ''}
                    },
                  }
                '';
            };
          }
      )
      {
        enable = true;
        settings.diagnostics_format = "#{m} [#{c}] (#{s})";
        sources = {
          diagnostics = {
            #gitlint.enable = true;
            todo_comments.enable = true;
            #dotenv_linter.enable = true;
          };
          # formatting.codespell.enable = true;
          code_actions.refactoring.enable = true;
          # no, handle this with cmp plugin
          # completion = {
          #   spell.enable = true;
          #   luasnip.enable = true;
          # };
          hover = {
            dictionary.enable = true;
            printenv.enable = true;
          };
        };
      }
    ];
  };
}
