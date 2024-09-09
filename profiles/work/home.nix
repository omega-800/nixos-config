{ globals, lib, usr, ... }:
with lib; {
  imports = [ ../../usr/wm ];

  # pkgs
  u = {
    dev.enable = mkDefault true;
    posix.enable = mkDefault true;
    work.enable = mkDefault true;
    file.enable = mkDefault true;
    net.enable = mkDefault true;
    office.enable = mkDefault true;
    user = {
      enable = mkDefault true;
      dirs = with globals.envVars; {
        enable = mkDefault true;
        extraDirs = mkDefault [
          "${WORKSPACE_DIR}/work/mgnl"
          "${WORKSPACE_DIR}/work/webview"
          "${WORKSPACE_DIR}/pers"
          "${XDG_DOCUMENTS_DIR}/work/shops"
          "${XDG_DOCUMENTS_DIR}/work/travel"
          "${XDG_DOCUMENTS_DIR}/pers"
        ];
      };
    };
    utils.enable = mkDefault true;

    # no fun only work
    media.enable = mkDefault true;
    social.enable = mkDefault false;
  };
}
