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
    ../work/${CONFIGS.homeConfigurations}.nix
  ];

  # pkgs
  u = {
    work.enable = mkHigherDefault false;
    media.enable = mkHigherDefault true;
    user.dirs = with globals.envVars; {
      extraDirs = mkHigherDefault [
        "${WORKSPACE_DIR}/school"
        "${WORKSPACE_DIR}/pers"
        "${XDG_DOCUMENTS_DIR}/school"
        "${XDG_DOCUMENTS_DIR}/pers"
      ];
    };
  };
}
