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
      changeDirWidget = {
        command = "fd --type d";
        options = [ "--preview 'tree -C {} | head -200'" ];
      };
      fileWidget = {
        command = "fd --type f";
        options = [ "--preview 'head {}'" ];
      };
      defaultCommand = "fd --type f";
      tmux.enableShellIntegration = true;
    };
  };
}
