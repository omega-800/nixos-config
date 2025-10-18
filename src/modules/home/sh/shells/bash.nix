{
  config,
  usr,
  globals,
  lib,
  sys,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.sh.bash;
in
{
  options.u.sh.bash.enable = mkOption {
    type = types.bool;
    default = usr.shell.pname == "bash";
  };
  config = mkIf cfg.enable {
    home.shell.enableBashIntegration = true;
    programs.bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [
        "ignorespace"
        "ignoredups"
      ];
      historyFile = globals.envVars.HISTFILE;
      historyFileSize = 100000;
      historyIgnore = [
        "ll"
        "ls"
        "exit"
        "cd"
        "clear"
        "c"
        "x"
        "l"
      ];
      historySize = 10000;
      shellOptions = [
        "checkwinsize"
        "extglob"
        "globstar"
        "histappend"
      ];
      bashrcExtra = with usr.termColors; ''
        PS1='\n\[\033[7;49;${c1}m\]\u\[\033[0;40;${c1}m\]\[\033[0;40;${c1}m\] \w\[\033[0;49;30m\]\[\033[m\]\n\[\033[7;49;${c2}m\]\h\[\033[0;40;${c2}m\]\[\033[0;40;${c2}m\] \j\[\033[7;49;${c2}m\]\[\033[7;49;${c2}m\] \s\[\033[0;40;${c2}m\]\[\033[0;40;${c2}m\] \!\[\033[0;49;30m\]\[\033[0;40;${c2}m\]\$\[\033[m\] '
              
        #bind 'set show-all-if-ambiguous on'
        #bind 'TAB:menu-complete'
        #bind '"\e[Z":menu-complete-backward'

        if [ -d ${globals.envVars.XDG_DOCUMENTS_DIR}/work/shops ]; then
          for dirname in $(find ${globals.envVars.XDG_DOCUMENTS_DIR}/work/shops/ -maxdepth 1 -type d);do
            [[ $dirname =~ ^.+/([^/]+)$ ]] && customer_id=$''${BASH_REMATCH[1]} && alias d_$customer_id="cd $dirname"
          done
        fi

        if [ -d ${globals.envVars.WORKSPACE_DIR}/work/mgnl ]; then
          for dirname in $(find ${globals.envVars.WORKSPACE_DIR}/work/mgnl/ -maxdepth 1 -type d);do
            [[ $dirname =~ ^.+/([^/]+)-workspace$ ]] && customer_id=$''${BASH_REMATCH[1]} && alias w_$customer_id="cd $dirname"
          done
        fi
      '';
      initExtra = ''
        set -o vi
        source ${./cdcomplete};
        _bcpp --defaults
        ${config.u.sh.shellInitExtra}
      '';
    };
  };
}
