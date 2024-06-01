{ config, pkgs, ... }: {
  config = mkif config.u.user.enabled {
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
};
}
