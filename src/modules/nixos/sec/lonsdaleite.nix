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
  # TODO: remove unused configs in this repo
  # FIXME: impermanence
  /*
    imports = [ inputs.lonsdaleite.nixosModules.lonsdaleite ];

    options.m.sec.lon.enable = mkEnableOption "lonsdaleite";

    config = mkIf cfg.enable {
      lonsdaleite = {
        enable = false;
        # FIXME:
        paranoia = # if sys.profile == "serv" then 2 else
          1;
        decapitated = sys.profile == "serv";
        trustedUser = usr.username;

        os = {
          antivirus.enable = true;
          nixos.enable = true;
          privilege.enable = true;
          random.enable = true;
          update.enable = true;
        };
        hw.bluetooth.enable = true;
        fs.usb.enable = true;
        net = {
          ssh.enable = true;
          sshd.enable = true;
          macchanger.enable = true;
          firewall.enable = true;
        };
      };
    };
  */
}
