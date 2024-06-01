{ pkgs, ... }: {
  home.packages = with pkgs; [ neovim ];
  programs.vim = {
    enable = true;
    #defaultEditor = true;
    settings = {
      background = "dark";
      mousehide = true;
    };
    extraConfig = builtins.readFile ./.vimrc;
  }; 
}
