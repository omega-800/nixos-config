{ lib, globals, ... }:
with globals.envVars; {
  home.activation.createDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for d in "${XDG_MUSIC_DIR}" "${XDG_VIDEOS_DIR}" "${XDG_PICTURES_DIR}" \
             "${XDG_PUBLICSHARE_DIR}" "${XDG_TEMPLATES_DIR}" "${XDG_DESKTOP_DIR}" \
             "${XDG_DOWNLOAD_DIR}" "${WORKSPACE_DIR}" "${SCREENSHOTS_DIR}" 
    do 
      [ -d "$d" ] || mkdir -p "$d"
    done
  '';
}
