{
  usr,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim.opts = {
    # completeopt = [ "menu" "menuone" "noselect" ];
    updatetime = 50; # Faster completion
    exrc = true;
    secure = true;

    number = true;
    relativenumber = true;
    splitbelow = true;
    splitright = true;
    scrolloff = 8;

    autoindent = true;
    expandtab = true;
    shiftwidth = 2;
    tabstop = 2;
    softtabstop = 2;
    smartindent = true;

    ignorecase = true;
    incsearch = true;
    smartcase = true;
    wildmenu = true;
    wildmode = "list:longest";
    wildignore = "*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx";
    path = ".,,**";

    colorcolumn = "120";
    cursorline = true;
    cursorcolumn = true;
    autoread = true;
    guicursor = "";
    mouse = "";
    # foldmethod = "indent";
    # foldnestmax = 10;
    # foldlevel = 5;
    # foldenable = true;
    showmode = true;
    showmatch = true;
    showcmd = true;
    history = 1000;

    swapfile = false;
    undofile = true; # Build-in persistent undo
    #undodir = "~/.vim/undodir";

    termguicolors = lib.mkForce pkgs.stdenv.isLinux;
  };
}
