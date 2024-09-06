{ lib, usr, globals, ... }: {
  imports = [
    # basically like work profile but with fun enabled
    ../work/home.nix
  ];

  # pkgs
  u = {
    work.enable = lib.my.mkHigherDefault false;
    media.enable = lib.my.mkHigherDefault true;
    social.enable = lib.my.mkHigherDefault true;
    user.dirs = with globals.envVars; {
      extraDirs = lib.my.mkHigherDefault [
        "${WORKSPACE_DIR}/homelab"
        "${WORKSPACE_DIR}/code"
        "${XDG_DOCUMENTS_DIR}/trading"
        "${XDG_DOCUMENTS_DIR}/pers"
        "${XDG_DOCUMENTS_DIR}/homelab"
      ];
    };
  };
}
