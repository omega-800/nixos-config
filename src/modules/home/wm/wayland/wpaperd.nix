{
  config,
  lib,
  PATHS,
  usr,
  pkgs,
  sys,
  ...
}:
let
  cfg = config.u.wm.wayland;
  inherit (lib)
    mkIf
    isList
    mkForce
    concatMapStringsSep
    ;
  theme = import (PATHS.THEMES + /${usr.theme}.nix);
in
{
  services.wpaperd = mkIf (cfg.enable && (isList theme.bg)) {
    enable = true;
    settings.any = {
      path =
        # (pkgs.symlinkJoin { name = "bg-images"; paths = map pkgs.fetchurl theme.bg; })
        mkForce (derivation {
          name = "bg-images";
          inherit (sys) system;
          builder = "${pkgs.bash}/bin/bash";
          args = [
            "-c"
            "${pkgs.coreutils}/bin/mkdir -p $out && ${
              concatMapStringsSep " && " (
                i: "${pkgs.coreutils}/bin/ln -sf \"${pkgs.fetchurl i}\" \"$out/${i.name}\""
              ) theme.bg
            }"
          ];
        });
      duration = "5m";
      mode = "center";
    };
  };
}
