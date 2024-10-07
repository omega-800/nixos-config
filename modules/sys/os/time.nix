{ sys, config, lib, ... }: {
  config = lib.mkMerge [
    (lib.mkIf sys.hardened {
      networking.timeServers =
        [ "ntp.3eck.net" "ntp.trifence.ch" "ntp.zeitgitter.net" ];

      environment.persistence =
        lib.mkIf config.m.fs.disko.root.impermanence.enable {
          "/nix/persist".directories = [ "/var/lib/chrony" ];
        };

      services.chrony = {
        enable = true;
        extraFlags = [ "-F 1" ];
        enableNTS = true;
        enableRTCTrimming = false;
        # The below config is borrowed from GrapheneOS server infrastructure.
        # It enables NTS to secure NTP requests, among some other useful
        # settings.
        # https://github.com/GrapheneOS/infrastructure/blob/main/chrony.conf
        extraConfig = ''
          server time.cloudflare.com iburst nts
          server ntppool1.time.nl iburst nts
          server nts.netnod.se iburst nts
          server ptbtime1.ptb.de iburst nts
          server time.dfm.dk iburst nts
          server time.cifelli.xyz iburst nts

          minsources 3
          authselectmode require

          # EF
          dscp 46

          driftfile /var/lib/chrony/drift
          ntsdumpdir /var/lib/chrony

          leapsectz right/UTC
          makestep 1.0 3

          rtconutc
          rtcsync

          cmdport 0

          noclientlog
        '';
      };
    })
    (lib.mkIf (!sys.hardened) {
      networking.timeServers = [
        "0.ch.pool.ntp.org"
        "1.ch.pool.ntp.org"
        "2.ch.pool.ntp.org"
        "3.ch.pool.ntp.org"
      ];
      services.timesyncd.enable = true;
    })
    { time.timeZone = sys.timezone; }
  ];
}
