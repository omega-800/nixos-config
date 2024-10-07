{ lib, config, pkgs, sys, ... }:
with lib;
let cfg = config.m.net.macchanger;
in {
  options.m.net.macchanger.enable = mkOption {
    description = "enables macchanger";
    type = types.bool;
    default = sys.paranoid && config.m.net.enable;
  };

  config = mkIf cfg.enable {
    systemd.services.macchanger = {
      enable = true;
      description = "Change MAC address";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.macchanger}/bin/macchanger -r wlp0s20f3";
        ExecStop = "${pkgs.macchanger}/bin/macchanger -p wlp0s20f3";
        RemainAfterExit = true;
      };
    };
  };
}
