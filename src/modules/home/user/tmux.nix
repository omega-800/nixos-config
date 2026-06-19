{
  globals,
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkOption mkIf;
  cfg = config.u.user.tmux;
in
{
  options.u.user.tmux.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ tmux ];
    programs.tmux = {
      enable = true;
      clock24 = true;
      newSession = true;
      historyLimit = 5000;
      plugins = with pkgs.tmuxPlugins; [
        cpu
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = "	 set -g @continuum-restore 'on'\n	 set -g @continuum-save-interval '10' # minutes\n ";
        }
        { plugin = vim-tmux-navigator; }
      ];

      extraConfig = ''
        ${builtins.readFile ./.tmux.conf}
        bind o run "${pkgs.writeShellScript "open-github-project" ''
          cd "$(tmux run "echo #{pane_start_path}")"}
          url="$(git remote get-url origin)"
          if [[ "$url" == git@* ]]; then 
            url="$${url#git@}"
            url="https://$${url/://}"
          fi
          xdg-open "$url" || echo "No remote found"
        ''}"

        bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel '${
          if usr.wmType == "x11" then "xclip -in -sel c" else "wl-copy"
        }'

        set-environment -g TMUX_PLUGIN_MANAGER_PATH '${globals.envVars.TMUX_PLUGIN_MANAGER_PATH}'
        # needed for yazi
        set -g allow-passthrough on
        set -ga update-environment TERM
        set -ga update-environment TERM_PROGRAM

        set-option -ga terminal-overrides ",xterm-256color:Tc"

        bind N split-window -h -l 3 -b "printf '\e[7;49;${usr.termColors.c1}m\e[0;40;${usr.termColors.c1}m' && echo {200..0} | tr ' ' '\n' && read" \; select-pane -l
      ''
      + (
        if usr.style then
          with config.lib.stylix.colors;
          ''
            # Default statusbar color
            set-option -g status-style bg="#${base01}",fg="#${base0F}"

            # Default window title colors
            set-window-option -g window-status-style bg="#${base06}",fg="#${base01}"

            # Default window with an activity alert
            set-window-option -g window-status-activity-style bg="#${base01}",fg="#${base0D}"

            # Active window title colors
            set-window-option -g window-status-current-style bg="#${base02}",fg="#${base01}"

            # Set active pane border color
            set-option -g pane-active-border-style fg="#${base0E}"

            # Set inactive pane border color
            set-option -g pane-border-style fg="#${base04}"

            # Message info
            set-option -g message-style bg="#${base01}",fg="#${base0B}"

            # Writing commands inactive
            set-option -g message-command-style bg="#${base01}",fg="#${base07}"

            # Pane number display
            set-option -g display-panes-active-colour "#${base05}"
            set-option -g display-panes-colour "#${base01}"

            # Clock
            set-window-option -g clock-mode-colour "#${base03}"

            # Bell
            set-window-option -g window-status-bell-style bg="#${base08}",fg="#${base01}"

            set-option -g status-left "\
            #[fg="#${base0F}", bg="#${base02}"]#{?client_prefix,#[bg="#${base0D}"],} #S \
            #[fg="#${base02}", bg="#${base01}"]#{?client_prefix,#[fg="#${base0D}"],}#{?window_zoomed_flag, ⭘,} "

            set-window-option -g window-status-current-format "\
            #[fg="#${base01}", bg="#${base0E}"]\
            #[fg="#${base01}", bg="#${base0E}"] #I* \
            #[fg="#${base01}", bg="#${base0E}", bold] #W \
            #[fg="#${base0E}", bg="#${base01}"]"

            set-window-option -g window-status-format "\
            #[fg="#${base01}",bg="#${base03}",noitalics]\
            #[fg="#${base0E}",bg="#${base03}"] #I \
            #[fg="#${base0E}", bg="#${base03}"] #W \
            #[fg="#${base03}", bg="#${base01}"]"
            set -g status-right-length 120
            set-option -g status-right "\
            #[fg="#${base02}", bg="#${base01}"]\
            #[fg="#${base08}", bg="#${base02}"] #h\
            #[fg="#${base09}", bg="#${base02}"]  [E]#(ip a | grep -vE '(veth|br-|docker)' | grep -E 'e.*:.*state UP' -A 3 | awk '/inet /{printf $2}')\
            #[fg="#${base0A}", bg="#${base02}"]  [W]#(ip a | grep -vE '(veth|br-|docker)' | grep -E 'wl.*state UP' -A 3 | awk '/inet /{printf $2}')\
            #[fg="#${base0B}", bg="#${base02}"]  [I]#(curl ifconfig.me)\
            #[fg="#${base0C}", bg="#${base02}"]  [V]#(ip a | grep -E 'wg0|ppp0|tun0|home' -A 3 | awk '/inet /{printf $2}' | grep '\.' || echo ''') \
            #[fg="#${base0D}", bg="#${base06}"]" 
          ''
        else
          ""
      );
    };
  };
}
