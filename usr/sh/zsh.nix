{ ... }: {
  programs = {
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      #defaultKeymap = "vicmd";
      history = {
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignorePatterns = [ "ll" "ls" "exit" "cd" "clear" "c" "x" "l" ];
        ignoreSpace = true;
        save = 10000;
        size = 100000;
        share = true;
      };
      autosuggestions.enable = true;
      zsh-autoenv.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
            "git"
            "git-extras"
            "docker"
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
