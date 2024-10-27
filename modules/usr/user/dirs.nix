{ lib
, globals
, config
, ...
}:
with globals.envVars;
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkIf
    concatStrings
    ;
  cfg = config.u.user.dirs;
in
{
  options.u.user.dirs = {
    enable = mkEnableOption "creates directories";
    extraDirs = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };
  config.home.activation.createDirs = mkIf cfg.enable (
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for d in "${XDG_MUSIC_DIR}" "${XDG_VIDEOS_DIR}" "${XDG_PICTURES_DIR}" \
               "${XDG_PUBLICSHARE_DIR}" "${XDG_TEMPLATES_DIR}" "${XDG_DESKTOP_DIR}" \
               "${XDG_DOWNLOAD_DIR}" "${WORKSPACE_DIR}" "${SCREENSHOTS_DIR}" \
               "${SCRIPTS_DIR}" "${ZDOTDIR}" "${SHELLDIR}" \
               ${concatStrings (map (d: ''"${d}" '') cfg.extraDirs)}
      do 
        [ -d "$d" ] || mkdir -p "$d"
      done
    ''
  );
}
