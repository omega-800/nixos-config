{ config, lib, ... }:
with lib; {
  config = mkIf config.u.user.enable {
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
