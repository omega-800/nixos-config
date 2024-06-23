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

        extraConfig = let 
  c1 = config.lib.stylix.colors.base01;
  c2 = config.lib.stylix.colors.base00;
  c3 = config.lib.stylix.colors.base04;
  c4 = config.lib.stylix.colors.base06;
  c5 = config.lib.stylix.colors.base07;
  c6 = config.lib.stylix.colors.base08;
  c7 = config.lib.stylix.colors.base09;
  c8 = config.lib.stylix.colors.base0D;
  c9 = config.lib.stylix.colors.base0F;
  c10 = config.lib.stylix.colors.base02;
  c11 = config.lib.stylix.colors.base03;
  c12 = config.lib.stylix.colors.base05;
  c13 = config.lib.stylix.colors.base0A;
in ''
${builtins.readFile ./.tmux.conf}
set-option -ga terminal-overrides ",xterm-256color:Tc"

# Default statusbar color
set-option -g status-style bg="#${c1}",fg="#${c10}"

# Default window title colors
set-window-option -g window-status-style bg="#${c4}",fg="#${c1}"

# Default window with an activity alert
set-window-option -g window-status-activity-style bg="#${c1}",fg="#${c8}"

# Active window title colors
set-window-option -g window-status-current-style bg="#${c10}",fg="#${c1}"

# Set active pane border color
set-option -g pane-active-border-style fg="#${c4}"

# Set inactive pane border color
set-option -g pane-border-style fg="#${c3}"

# Message info
set-option -g message-style bg="#${c3}",fg="#${c10}"

# Writing commands inactive
set-option -g message-command-style bg="#${c3}",fg="#${c10}"

# Pane number display
set-option -g display-panes-active-colour "#${c12}"
set-option -g display-panes-colour "#${c1}"

# Clock
set-window-option -g clock-mode-colour "#${c11}"

# Bell
set-window-option -g window-status-bell-style bg="#${c7}",fg="#${c13}"

set-option -g status-left "\
#[fg="#${c5}", bg="#${c6}"]#{?client_prefix,#[bg="#${c7}"],} ⚡ #S \
#[fg="#${c6}", bg="#${c3}"]#{?client_prefix,#[fg="#${c7}"],}#{?window_zoomed_flag, ⭘,}"

set-window-option -g window-status-current-format "\
#[fg="#${c1}", bg="#${c3}"]\
#[fg="#${c4}", bg="#${c3}"] #I* \
#[fg="#${c4}", bg="#${c3}", bold] #W \
#[fg="#${c3}", bg="#${c1}"]"

set-window-option -g window-status-format "\
#[fg="#${c1}",bg="#${c2}",noitalics]\
#[fg="#${c3}",bg="#${c2}"] #I \
#[fg="#${c3}", bg="#${c2}"] #W \
#[fg="#${c2}", bg="#${c1}"]"

set-option -g status-right "\
#[fg="#${c3}", bg="#${c1}"]  %d %b '%y\
#[fg="#${c9}"]  %H:%M \
#[fg="#${c8}", bg="#${c4}"]"
        '';
      };
    };
}
