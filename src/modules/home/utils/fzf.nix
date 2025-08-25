{ lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.fzf;
in
{
  options.u.utils.fzf.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable;
  };

  config = mkIf cfg.enable {
    programs.fd = {
      enable = true;
      hidden = true;
    };
    programs.fzf = {
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
  };
}
