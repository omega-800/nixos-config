{
  inputs,
  config,
  lib,
  usr,
  sys,
  ...
}:
let
  cfg = config.m.sec.lon;
  inherit (lib) mkEnableOption mkIf;
in
{
  # will have to fix impermanence first
  /*
    imports = [ inputs.lonsdaleite.nixosModules.lonsdaleite ];

    options.m.sec.lon.enable = mkEnableOption "lonsdaleite";

    config = mkIf cfg.enable {
      lonsdaleite = {
        enable = false;
        # FIXME:
        paranoia =
          if sys.profile == "serv" then
            2
          else if sys.profile == "pers" then
            1
          else
            0;
        decapitated = sys.profile == "serv";
        trustedUser = usr.username;

        os.systemd.enable = true;
      };
    };
  */
}
