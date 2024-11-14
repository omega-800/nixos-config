{
  usr,
  config,
  lib,
  pkgs,
sys,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.net.chromium;
in
{
  options.u.net.chromium.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal && sys.profile == "work";
  };
  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.nixGL pkgs.chromium;
      extensions = [
        "gcbommkclmclpchllfjekcdonpmejbdp" # https everywhere
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
        "fihnjjcciajhdojfnbdddfaoknhalnja" # i don't care about cookies
        "fhcgjolkccmbidfldomjliifgaodjagh" # cookie autodelete
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # privacy badger
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-ch
rome/master/updates.xml";
        }
      ];
    };
  };
}
