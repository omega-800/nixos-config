{ pkgs, ... }: {
  users.defaultUserShell = pkgs.bash;
  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
}
