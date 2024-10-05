{ sys, lib, config, pkgs, ... }:
let
  cfg = config.m.hw.intel;
  inherit (lib) mkOption types mkIf;
in {
  options.m.hw.intel = {
    disable = mkOption {
      type = types.bool;
      default = sys.hardened && (sys.system != "x86_64-linux");
      description = "disables intel kernel modules";
    };
  };
  config = mkIf cfg.disable {
    environment = {
      persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
        "/nix/persist".files =
          [ "/etc/modprobe.d/nm-disable-intelme-kmodules.conf" ];
      };
      etc."modprobe.d/nm-disable-intelme-kmodules.conf" = {
        text = ''
          install mei /usr/bin/disabled-intelme-by-security-misc
          install mei-gsc /usr/bin/disabled-intelme-by-security-misc
          install mei_gsc_proxy /usr/bin/disabled-intelme-by-security-misc
          install mei_hdcp /usr/bin/disabled-intelme-by-security-misc
          install mei-me /usr/bin/disabled-intelme-by-security-misc
          install mei_phy /usr/bin/disabled-intelme-by-security-misc
          install mei_pxp /usr/bin/disabled-intelme-by-security-misc
          install mei-txe /usr/bin/disabled-intelme-by-security-misc
          install mei-vsc /usr/bin/disabled-intelme-by-security-misc
          install mei-vsc-hw /usr/bin/disabled-intelme-by-security-misc
          install mei_wdt /usr/bin/disabled-intelme-by-security-misc
          install microread_mei /usr/bin/disabled-intelme-by-security-misc
        '';
      };
    };
  };
}
