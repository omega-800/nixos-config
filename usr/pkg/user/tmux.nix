{ lib, config, pkgs, home, ... }: with lib; {
  config = mkIf config.u.user.enable {
    home.packages = with pkgs; [ tmux ];
    programs.tmux = {
        enable = true;
        clock24 = true;
        historyLimit = 5000;
        plugins = with pkgs.tmuxPlugins; [
					 cpu
					 {
						 plugin = resurrect;
						 extraConfig = "set -g @resurrect-strategy-nvim 'session'";
					 }
					 {
						 plugin = continuum;
						 extraConfig = ''
							 set -g @continuum-restore 'on'
							 set -g @continuum-save-interval '10' # minutes
						 '';
					 }
           {
             plugin = vim-tmux-navigator;
					 }
				 ];

        extraConfig = builtins.readFile ./.tmux.conf;
      };
    };
}
