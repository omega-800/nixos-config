{ pkgs, lib, usr, ... }: {
  config = lib.mkMerge [
  {
    users.defaultUserShell = usr.shell;
  }
  (lib.mkIf (usr.shell.pname == "zsh") {
     environment.shells = with pkgs; [ zsh ];
     programs.zsh.enable = true;
     environment.pathsToLink = [ "/share/zsh" ];
   })
  ];
}
