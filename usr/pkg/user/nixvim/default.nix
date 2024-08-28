{ inputs, config, lib, usr, ... }:
with lib;
let
  cfg = config.u.user.nixvim;
  mapCfgImports = modules:
    map (m: (import m { enabled = cfg.enabled; })) modules;
in
{
  options.u.user.nixvim.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal;
  };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./lsp
    ./git
    ./style
    ./utils
    ./cmp
    ./opts
    ./autocmd
    ./dap
    ./py
  ];

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      enableMan = true;
      viAlias = true;
      vimAlias = true;
      editorconfig.enable = true;
      clipboard = {
        register = "unnamedplus";
        providers = {
          xclip.enable = usr.wmType == "x11";
          wl-copy.enable = usr.wmType != "x11";
        };
      };
      extraConfigVim = ''
        syntax on
        hi Normal guibg=NONE ctermfg=None ctermbg=DarkGreen
        hi Cursor guibg=NONE ctermfg=None ctermbg=DarkGreen
        hi CursorColumn guibg=NONE ctermfg=None ctermbg=Black
        hi CursorLine guibg=NONE ctermfg=None ctermbg=Black
        hi ColorColumn ctermbg=235 guibg=#262626
        filetype on
        filetype plugin on
        filetype indent on
      '';
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      autoCmd = [
        # Open help in a vertical split
        {
          event = "FileType";
          pattern = "help";
          command = "wincmd L";
        }

        # Enable spellcheck for some filetypes
        {
          event = "FileType";
          pattern = [ "markdown" ];
          command = "setlocal spell spelllang=en,de";
        }
      ];
    };
  };
}
