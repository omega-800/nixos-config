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
    optionals
    mkOption
    types
    mkIf
    ;
  cfg = config.u.net.chromium;
in
{
  options.u.net.chromium.enable = mkOption {
    type = types.bool;
    default = config.u.net.enable && !usr.minimal;
  };
  config = mkIf cfg.enable {
    home.sessionVariables = mkIf (usr.wmType == "wayland") {
      NIXOS_OZONE_WL = "1";
    };

    programs.chromium = {
      enable = true;
      #package = pkgs.nixGL pkgs.chromium;
      commandLineArgs = optionals (usr.wmType == "wayland") [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];
      extensions = [
        { id = "gcbommkclmclpchllfjekcdonpmejbdp"; } # https everywhere
        { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # darkreader
        { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # i don't care about cookies
        { id = "fhcgjolkccmbidfldomjliifgaodjagh"; } # cookie autodelete
        { id = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp"; } # privacy badger
        {
          id = "dcpihecpambacapedldabdbpakmachpb";
          updateUrl = "https://raw.githubusercontent.com/iamadamdev/bypass-paywalls-chrome/master/updates.xml";
        }
      ]
      ++ (optionals (sys.profile == "school") [
        { id = "ohgndokldibnndfnjnagojmheejlengn"; } # citavi
      ]);
    };
  };
}
