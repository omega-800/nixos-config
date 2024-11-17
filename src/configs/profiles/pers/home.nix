{
  lib,
  globals,
  CONFIGS,
  ...
}:
let
  inherit (lib.omega.def) mkHigherDefault;
in
{
  imports = [
    # basically like work profile but with fun enabled
    ../work/${CONFIGS.homeConfigurations}.nix
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
        "${WORKSPACE_DIR}/configs"
        "${XDG_DOCUMENTS_DIR}/trading"
        "${XDG_DOCUMENTS_DIR}/pers/diary"
        "${XDG_DOCUMENTS_DIR}/projects/homelab"
      ];
    };
  };
}
