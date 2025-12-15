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
  inherit (lib) mkIf mkDefault mkMerge;
  inherit (lib.omega.def) mkDisableOption;
  inherit (lib.omega.cfg) mkSpecialisation;
in
{
  # TODO: remove unused configs in this repo

  imports = [ inputs.lonsdaleite.nixosModules.lonsdaleite ];

  options.m.sec.lon.enable = mkDisableOption "lonsdaleite";

  config = mkIf cfg.enable (mkMerge [
    (
      (mkSpecialisation "serv" {
        lonsdaleite = {
          decapitated = true;
          hw.bluetooth.disable = true;
        };
      })
      // (mkSpecialisation "school" {
        lonsdaleite.net.ssh.enable = false;
      })
    )
    {
      lonsdaleite = {
        enable = false;
        # FIXME:
        paranoia = # if sys.profile == "serv" then 2 else
          1;
        decapitated = mkDefault false;
        trustedUser = usr.username;

        os = {
          antivirus.enable = true;
          # nixos.enable = true;
          # privilege.enable = true;
          random.enable = true;
          update.enable = true;
        };
        # hw.bluetooth.enable = sys.profile != "serv";
        hw.bluetooth = {
          enable = false;
          disable = mkDefault false;
        };
        fs.usb = {
          enable = false;
          disable = false;
        };
        net = {
          ssh.enable = mkDefault true;
          sshd.enable = true;
          macchanger.enable = true;
          firewall.enable = true;
        };
        sw.disable.enable = true;
      };
    }
  ]);
}
