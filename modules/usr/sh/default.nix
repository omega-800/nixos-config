{
  globals,
  usr,
  pkgs,
  ...
}:
let
  diaryDir = "${globals.envVars.XDG_DOCUMENTS_DIR}/diary/$(date +%Y)/$(date +%m)";
  diaryEntry = "${diaryDir}/$(date +%d).md";
  diaryStartup = pkgs.writeShellScriptBin "diary-current-list" ''
    [ -d "${diaryDir}" ] || mkdir -p "${diaryDir}"
    [ -f "${diaryEntry}" ] || cat > "${diaryEntry}"<< EOF
    # $(date +%F) 

    - [ ] goal A
    - [ ] goal B
    - [ ] goal C
    EOF

    cat "${diaryEntry}"
  '';

  diaryEdit = pkgs.writeShellScriptBin "diary-edit" ''
    ${globals.envVars.EDITOR} "${diaryEntry}"
  '';

  shellInitExtra = ''
    source ${./functions};
    source ${./ssh};

    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export PINENTRY_USER_DATA=USE_TTY=1
    export GPG_TTY=$(tty)
    unset SSH_ASKPASS
    unset GIT_ASKPASS

    ${diaryStartup}/bin/diary-current-list
  '';
in
{
  imports = [
    ./aliases.nix
    ./env.nix
    (import ./shells/${usr.shell.pname}.nix { inherit shellInitExtra; })
    ./posix.nix
  ];
  home.packages = with pkgs; [
    diaryStartup
    diaryEdit
  ];
}
