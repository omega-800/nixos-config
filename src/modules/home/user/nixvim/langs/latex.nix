{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf optionals;
  inherit (lib.omega.vim) keyG key;
  inherit (builtins) elem;
  enabled = elem "latex" config.u.user.nixvim.langSupport;
  inherit (config.programs.nixvim) plugins;
in
{
  config.home.packages = optionals enabled (
    with pkgs;
    [
      latexrun
      (texlive.combine {
        inherit (texlive)
          scheme-basic
          cite
          courier
          csquotes
          biblatex
          biblatex-ieee
          amsmath
          hyperref
          geometry
          listings
          pxfonts
          babel-german
          babel-english
          babel-russian
          ;
      })
    ]
  );
  # config.programs.texlive = mkIf enabled {
  #   enable = true;
  #   packageSet = pkgs.texlive.combined.scheme-basic;
  #   # TODO:
  #   # extraPackages = p: {inherit (p) collection-basic; };
  # };
  /*
    To compile, just map: nmap <leader>cc :w<cr> :!pdflatex %:r.tex && bibtex %:r.aux && pdflatex %:r.tex && pdflatex %:r.tex && rm %:r.aux %:r.log %:r.blg %:r.bbl<cr>
    To view the file in Zathura: nmap <leader>cv :!zathura %:r.pdf > /dev/null 2>&1 &<cr><cr>
  */
  config.programs.nixvim = mkIf enabled {
    keymaps = keyG "<leader>z" "latex/typst" [
      (key "n" "l"
        ":w<cr> :!pdflatex %:r.tex && bibtex %:r.aux && pdflatex %:r.tex && pdflatex %:r.tex && rm %:r.aux %:r.log %:r.blg %:r.bbl<cr>"
        "compile latex"
      )
      (key "n" "z" ":!zathura %:r.pdf > /dev/null 2>&1 &<cr><cr>" "view pdf")
    ];
    plugins = {
      lsp = {
        servers.texlab.enable = true;
      };
      vimtex = {
        # enable = true;
        autoLoad = true;
        settings = {
          view_method = "zathura";
          compiler_method = "latexrun";
        };
      };
    };
  };
}
