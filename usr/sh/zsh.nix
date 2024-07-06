{ shellInitExtra }:
{ config, ... }: {
  imports = [ (import ./bash.nix { inherit shellInitExtra; }) ];
  programs = {
    bash.initExtra = "exec zsh";
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
      initExtra = ''
        ${shellInitExtra}
        setopt noautomenu
        #PROMPT=$${PROMPT/\%c/\%~}
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
        theme = "robbyrussell";
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
