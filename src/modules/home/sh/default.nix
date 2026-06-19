{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;

  shellInitExtra = ''
    source ${pkgs.functions};
    source ${pkgs.ssh};

    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export PINENTRY_USER_DATA=USE_TTY=1
    export GPG_TTY=$(tty)
    unset SSH_ASKPASS
    unset GIT_ASKPASS
  '';
in
{
  imports = [
    ./aliases.nix
    ./env.nix
    ./shells
    ./posix.nix
  ];
  options.u.sh.shellInitExtra = mkOption {
    type = types.str;
    default = shellInitExtra;
  };
}
