{ pkgs, ... }: {
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.bash;
  programs.zsh.enable = true;
}
