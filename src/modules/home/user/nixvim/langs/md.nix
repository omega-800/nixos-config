{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "md" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.programs.nixvim = mkIf enabled {
    plugins = {
      lsp.servers = mkIf plugins.lsp.enable {
        marksman.enable = true;
      };
      none-ls.sources = mkIf plugins.none-ls.enable {
        formatting = {
          #markdownlint.enable = true;
          #mdformat.enable = true;
        };
      };
    };
    extraConfigVim = ''
      " Presenterm comment command helper
      if executable('presenterm') && executable('fzf')
        inoremap <expr> <c-k> fzf#vim#complete(fzf#wrap({
              \ 'source':  'presenterm --list-comment-commands',
              \ 'options': '--header "Comment Command Selection" --no-hscroll',
              \ 'reducer': { lines -> lines[0] } }))
      endif
    '';
  };
}
