{ config, usr, ... }:
let
  shellInitExtra = ''
    source ${./functions};
    source ${./ssh};

    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export PINENTRY_USER_DATA=USE_TTY=1
    export GPG_TTY=$(tty)
  '';
in {
  imports = [
    ./aliases.nix
    ./env.nix
    (import ./shells/${usr.shell.pname}.nix { inherit shellInitExtra; })
    ./posix.nix
  ];
}
