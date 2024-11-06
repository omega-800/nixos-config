{ inputs
, config
, lib
, usr
, sys
, ...
}:
with lib;
let
  cfg = config.u.user.nixvim;
in
# what exactly was i planning with this??
  # mapCfgImports = modules: map (m: (import m { inherit (cfg) enabled; })) modules;
{
  options.u.user.nixvim = {
    enable = mkOption {
      type = types.bool;
      default = config.u.user.enable && !usr.minimal;
    };
    langSupport = mkOption {
      type = types.listOf (
        types.enum [
          # includes ts, vue, json and node
          "js"
          # includes bash
          "sh"
          # includes cpp
          "c"
          # includes scss and tailwind
          "css"
          # includes ansible and docker compose
          "yaml"
          # includes htmx
          "html"
          # includes jupyter
          "python"
          # includes elixir
          "erlang"
          # includes psql
          "sql"
          "go"
          "java"
          "md"
          "nix"
          "gql"
          "docker"
          "lua"
          "rust"
        ]
      );
      default = [
        "sh"
        "md"
        "nix"
      ];
    };
  };

  imports = [
    ./lsp
    ./git
    ./style
    ./utils
    ./cmp
    ./opts
    ./autocmd
    ./dap
    ./py
    ./rust
    inputs.nixvim.homeManagerModules.nixvim
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
