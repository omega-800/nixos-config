{ config, pkgs, lib, ... }: with lib; {
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];
  config = mkIf config.u.user.enable {
    #home.packages = with pkgs; [ neovim ];
    programs = {
      nixvim = {
        enable = true;
      };
      vim = {
        enable = true;
        #defaultEditor = true;
        settings = {
          background = "dark";
          mousehide = true;
        };
        extraConfig = builtins.readFile ./.vimrc;
      }; 
    };
  };
}
