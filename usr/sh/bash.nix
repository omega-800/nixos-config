{ shellInitExtra }:
{ config, usr, ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignorespace" "ignoredups" ];
    historyFile = "${config.home.homeDirectory}/.local/state/bash/history";
    historyFileSize = 100000;
    historyIgnore = [ "ll" "ls" "exit" "cd" "clear" "c" "x" "l" ];
    historySize = 10000;
    shellOptions = [ "checkwinsize" "extglob" "globstar" "histappend" ];
    bashrcExtra = ''
      PS1='\n\[\033[7;49;35m\]\u\[\033[0;40;35m\]\[\033[0;40;35m\] \w\[\033[0;49;30m\]\[\033[m\]\n\[\033[7;49;91m\]\h\[\033[0;40;91m\]\[\033[0;40;91m\] \j\[\033[0;101;30m\]\[\033[7;49;91m\] \s\[\033[0;40;91m\]\[\033[0;40;91m\] \!\[\033[0;49;30m\]\[\033[5;49;91m\]\$\[\033[m\] '
            
      #PS1="\n$(tput setaf "$(fromhex "#${config.lib.stylix.colors.base08}")")\u $(tput setaf "$(fromhex "#${config.lib.stylix.colors.base0A}")")\w\n$(tput setaf "$(fromhex "#${config.lib.stylix.colors.base06}")")\h $(tput setaf "$(fromhex "#${config.lib.stylix.colors.base03}")")\j $(tput setaf "$(fromhex "#${config.lib.stylix.colors.base00}")")\s $(tput setaf "$(fromhex "#${config.lib.stylix.colors.base0E}")")\! $(tput setaf "$(fromhex "#${config.lib.stylix.colors.base0B}")")> $(tput sgr0)"

      #solved in the nix way
      #for i in {2..20}; do alias "$(printf '.%.0s' $(seq 1 $i))"="cd $(printf '../%.0s' $(seq 2 $i))"; done
      #bind 'set show-all-if-ambiguous on'
      #bind 'TAB:menu-complete'
      #bind '"\e[Z":menu-complete-backward'

      if [ -d /home/omega/documents/Shops ]; then
        for dirname in $(find /home/omega/documents/Shops/ -maxdepth 1 -type d);do
          [[ $dirname =~ ^.+/([^/]+)$ ]] && customer_id=$''${BASH_REMATCH[1]} && alias d_$customer_id="cd $dirname"
        done
      fi

      if [ -d /mnt/c/Users/GeorgiyShevoroshkin/coding-win/magnolia_webapps/ ]; then
        for dirname in $(find /mnt/c/Users/GeorgiyShevoroshkin/coding-win/magnolia_webapps/ -maxdepth 1 -type d);do
          [[ $dirname =~ ^.+/([^/]+)-workspace$ ]] && customer_id=$''${BASH_REMATCH[1]} && alias w_$customer_id="cd $dirname"
        done
      fi
    '';
    initExtra = ''
      set -o vi
      source ${./cdcomplete};
      _bcpp --defaults
      ${shellInitExtra}
    '';
  };
}
