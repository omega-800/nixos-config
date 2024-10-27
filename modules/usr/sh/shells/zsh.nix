{ shellInitExtra }:
{
  config,
  usr,
  globals,
  ...
}:
{
  imports = [ (import ./bash.nix { inherit shellInitExtra; }) ];
  programs = {
    #bash.initExtra = "exec zsh";
    # oh-my-posh = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   enableBashIntegration = false;
    #   useTheme = "capr4n";
    # };
    zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      dotDir = ".config/zsh"; # globals.envVars.ZDOTDIR;
      syntaxHighlighting = {
        enable = true;
        highlighters = [
          "main"
          "brackets"
          "line" # "cursor"
          "root"
        ];
        patterns = {
          "rm -rf" = "fg=white,bold,bg=red";
        };
      };
      #zprof.enable = true;
      zsh-abbr = {
        enable = true;
        abbreviations = config.home.shellAliases;
      };
      #defaultKeymap = "vicmd";
      #PROMPT=$'\n'"%F{#${base08}}%n%F{#${base0A}}%F{#${base0A}} %~%F{#${base0E}}%f$"$'\n'"%F{#${base00}}%m%F{#${base03}}%F{#${base03}} %j%F{#${base06}}%F{#${base00}} zsh%F{#${base03}}%F{#${base03}} %!%F{#${base0E}}%F{#${base0B}}%(!.%F{red}#.%F{green}$)%f "
      initExtra = with usr.termColors; ''
                          ${shellInitExtra}
                setopt noautomenu
        # "7;49;35" "0;40;35" "0;49;30" "7;49;91" "0;40;91" "0;101;30" "5;49;91"

                PROMPT=$'\n%{\e[7;49;${c1}m%}'"%n"$'%{\e[0;40;${c1}m%}'""$'%{\e[0;40;${c1}m%}'" %~"$'%{\e[0;49;30m%}'""$'%{\e[m%}\n%{\e[7;49;${c2}m%}'"%m"$'%{\e[0;40;${c2}m%}'""$'%{\e[0;40;${c2}m%}'" %j"$'%{\e[7;49;${c2}m%}'""$'%{\e[7;49;${c2}m%}'" zsh"$'%{\e[0;40;${c2}m%}'""$'%{\e[0;40;${c2}m%}'" %!"$'%{\e[0;49;30m%}'""$'%{\e[0;40;${c2}m%}'"%(!.#.$) "$'%{\e[m%}'
                # Autoload zsh's `add-zsh-hook` and `vcs_info` functions
                # (-U autoload w/o substition, -z use zsh style)
                autoload -Uz add-zsh-hook vcs_info

                # Set prompt substitution so we can use the vcs_info_message variable
                setopt prompt_subst

                # Run the `vcs_info` hook to grab git info before displaying the prompt
                add-zsh-hook precmd vcs_info
                # Style the vcs_info message
                zstyle ':vcs_info:*' enable git
                zstyle ':vcs_info:git*' formats $'%{\e[0;40;${c2}m%}'""$'%{\e[7;49;${c2}m%}'"%s "$'%{\e[0;40;${c2}m%}'"%b "$'%{\e[0;40;${c2}m%}'""$'%{\e[7;49;${c2}m%}'"%u%c "
                # Format when the repo is in an action (merge, rebase, etc)
                zstyle ':vcs_info:git*' actionformats $'%{\e[0;40;${c2}m%}'""$'%{\e[7;49;${c2}m%}'"%a"
                zstyle ':vcs_info:git*' unstagedstr '*'
                zstyle ':vcs_info:git*' stagedstr '+'
                # This enables %u and %c (unstaged/staged changes) to work,
                # but can be slow on large repos
                zstyle ':vcs_info:*:*' check-for-changes true

                # Set the right prompt to the vcs_info message
                RPROMPT=$'%{\e[0;49;30m%}'""$'%{\e[0;40;${c2}m%}'"%* "'$vcs_info_msg_0_'$'%{\e[m%}'
      '';
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignorePatterns = [
          "ll"
          "ls"
          "exit"
          "cd"
          "clear"
          "c"
          "x"
          "l"
        ];
        ignoreSpace = true;
        save = 10000;
        size = 100000;
        share = true;
        path = globals.envVars.HISTFILE;
      };
      oh-my-zsh = {
        enable = true;
        #theme = "robbyrussell";
        plugins =
          [
            "git"
            "docker"
            "tmux"
            "vi-mode"
            "history"
          ]
          ++ (
            if usr.extraBloat then
              [
                # "encode64"
                # "man"
                # "nmap"
                # "ssh-agent"
                # "sudo"
                # "systemd"
                "npm"
                "node"
                "git-extras"
                "git-auto-fetch"
              ]
            else
              [ ]
          );
      };
    };
  };
}
