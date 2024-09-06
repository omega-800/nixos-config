{ lib, usr, globals, ... }:
with lib.my.def; {
  imports = [
    # basically like work profile but with fun enabled
    ../work/home.nix
  ];

  # pkgs
  u = {
    work.enable = mkHigherDefault false;
    media.enable = mkHigherDefault true;
    social.enable = mkHigherDefault true;
    user.dirs = with globals.envVars; {
      extraDirs = mkHigherDefault [
        "${WORKSPACE_DIR}/homelab"
        "${WORKSPACE_DIR}/code"
        "${XDG_DOCUMENTS_DIR}/trading"
        "${XDG_DOCUMENTS_DIR}/pers"
        "${XDG_DOCUMENTS_DIR}/homelab"
      ];
    };
  };
}
