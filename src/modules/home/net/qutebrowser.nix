{
  usr,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.net.qutebrowser;
in
{
  options.u.net.qutebrowser.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      package = pkgs.nixGL pkgs.qutebrowser;
      greasemonkey = [
        # HTML5 Video Playing Tools
        (pkgs.fetchurl {
          url="https://update.greasyfork.org/scripts/30545/HTML5%E8%A7%86%E9%A2%91%E6%92%AD%E6%94%BE%E5%B7%A5%E5%85%B7.user.js";
          sha256="sha256-/C2IWVNYAAplAUaDhY0bkavdR0UjX0rqtYUDXDOpNE4=";
        })
        # youtube-adb
        (pkgs.fetchurl {
          url="https://update.greasyfork.org/scripts/459541/YouTube%E5%8E%BB%E5%B9%BF%E5%91%8A.user.js";
          sha256="sha256-l1jSu6wD8/77wf5TT9apxvy+6B+9ywVm6pmMkhM6Ex8=";
        })
        # Bypass paywalls for scientific documents
        (pkgs.fetchurl {
          url="https://update.greasyfork.org/scripts/35521/Bypass%20paywalls%20for%20scientific%20documents.user.js";
          sha256="sha256-AfnLiQl6JaaPOz4mn9K/47HDDwBGxKR+dGkaRzifl/Q=";
        })
      ];
    };
  };
}
