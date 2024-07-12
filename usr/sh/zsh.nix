{ shellInitExtra }:
{ config, ... }: {
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
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" "line" "cursor" "root" ];
        patterns = { "rm -rf" = "fg=white,bold,bg=red"; };
      };
      #zprof.enable = true;
      zsh-abbr = {
        enable = true;
        abbreviations = config.home.shellAliases;
      };
      #defaultKeymap = "vicmd";
      initExtra = with config.lib.stylix.colors; ''
                  ${shellInitExtra}
        #PS1='\n\[\033[7;49;35m\]\u\[\033[0;40;35m\]\[\033[0;40;35m\] \w\[\033[0;49;30m\]\[\033[m\]\n\[\033[7;49;91m\]\h\[\033[0;40;91m\]\[\033[0;40;91m\] \j\[\033[0;101;30m\]\[\033[7;49;91m\] \s\[\033[0;40;91m\]\[\033[0;40;91m\] \!\[\033[0;49;30m\]\[\033[5;49;91m\]\$\[\033[m\] '
        #REFERENCE_PROMPT='%(?.%F{green}✓.%F{red}×)%f %F{5}%~%f %(!.%F{red}#.%F{#123456}>)%f '
        #PROMPT=$'\n'"%F{#${base08}}%n%F{#${base0A}}%F{#${base0A}} %~%F{#${base0E}}%f$"$'\n'"%F{#${base00}}%m%F{#${base03}}%F{#${base03}} %j%F{#${base06}}%F{#${base00}} zsh%F{#${base03}}%F{#${base03}} %!%F{#${base0E}}%F{#${base0B}}%(!.%F{red}#.%F{green}$)%f "


        setopt noautomenu

        PROMPT=$'\n%{\e[7;49;35m%}'"%n"$'%{\e[0;40;35m%}'""$'%{\e[0;40;35m%}'" %~"$'%{\e[0;49;30m%}'""$'%{\e[m%}\n%{\e[7;49;91m%}'"%m"$'%{\e[0;40;91m%}'""$'%{\e[0;40;91m%}'" %j"$'%{\e[0;101;30m%}'""$'%{\e[7;49;91m%}'" zsh"$'%{\e[0;40;91m%}'""$'%{\e[0;40;91m%}'" %!"$'%{\e[0;49;30m%}'""$'%{\e[5;49;91m%}'"%(!.#.$) "$'%{\e[m%}'
        # Autoload zsh's `add-zsh-hook` and `vcs_info` functions
        # (-U autoload w/o substition, -z use zsh style)
        autoload -Uz add-zsh-hook vcs_info

        # Set prompt substitution so we can use the vcs_info_message variable
        setopt prompt_subst

        # Run the `vcs_info` hook to grab git info before displaying the prompt
        add-zsh-hook precmd vcs_info
        # Style the vcs_info message
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:git*' formats $'%{\e[0;40;91m%}'""$'%{\e[7;49;91m%}'"%s "$'%{\e[0;40;91m%}'"%b "$'%{\e[0;40;91m%}'""$'%{\e[7;49;91m%}'"%u%c "
        # Format when the repo is in an action (merge, rebase, etc)
        zstyle ':vcs_info:git*' actionformats $'%{\e[0;40;91m%}'""$'%{\e[7;49;91m%}'"%a"
        zstyle ':vcs_info:git*' unstagedstr '*'
        zstyle ':vcs_info:git*' stagedstr '+'
        # This enables %u and %c (unstaged/staged changes) to work,
        # but can be slow on large repos
        zstyle ':vcs_info:*:*' check-for-changes true

        # Set the right prompt to the vcs_info message
        RPROMPT=$'%{\e[0;49;30m%}'""$'%{\e[0;40;91m%}'"%* "'$vcs_info_msg_0_'$'%{\e[m%}'
      '';
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignorePatterns = [ "ll" "ls" "exit" "cd" "clear" "c" "x" "l" ];
        ignoreSpace = true;
        save = 10000;
        size = 100000;
        share = true;
      };
      oh-my-zsh = {
        enable = true;
        #theme = "robbyrussell";
        plugins = [
          "git"
          "git-extras"
          "git-auto-fetch"
          "docker"
          # "encode64"
          # "man"
          # "nmap"
          # "ssh-agent"
          # "sudo"
          # "systemd"
          "npm"
          "node"
          "tmux"
          "vi-mode"
          "history"
        ];
      };
    };
  };
}
