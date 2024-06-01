{ lib, config, ... }: with lib; {
  programs.fzf = mkIf config.u.utils.enable {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    defaultCommand = "fd --type f";
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview 'head {}'" ];
    tmux.enableShellIntegration = true;
  };
}
