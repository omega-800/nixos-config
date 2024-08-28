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
    bashrcExtra = with usr.termColors; ''
      PS1='\n\[\033[7;49;${c1}m\]\u\[\033[0;40;${c1}m\]\[\033[0;40;${c1}m\] \w\[\033[0;49;30m\]\[\033[m\]\n\[\033[7;49;${c2}m\]\h\[\033[0;40;${c2}m\]\[\033[0;40;${c2}m\] \j\[\033[7;49;${c2}m\]\[\033[7;49;${c2}m\] \s\[\033[0;40;${c2}m\]\[\033[0;40;${c2}m\] \!\[\033[0;49;30m\]\[\033[0;40;${c2}m\]\$\[\033[m\] '
            
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
