{ lib, config, pkgs, ... }:
with lib;
let cfg = config.m.hw.audio;
in {
  options.m.hw.audio = {
    enable = mkEnableOption "enables audio";
    pipewire = mkEnableOption "enables pipewire, pulseaudio otherwise";
    bluetooth = mkEnableOption "enables bluetooth";
  };

  config = mkIf cfg.enable (mkMerge [
    ({
      # Enable sound.
      # sound.enable = true;
      hardware.pulseaudio.enable = !cfg.pipewire;
      environment.systemPackages =
        [ pkgs.pulseaudio ]; # even if pulseaudio is disables bc of pactl

      # rtkit is optional but recommended
      security.rtkit.enable = cfg.pipewire;
      services.pipewire = (if cfg.pipewire then {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      } else {
        enable = false;
      });
    })
    (mkIf cfg.bluetooth {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = !lib.paranoid;
        # enables showing battery charge of devices
        settings = lib.mkMerge [
          { General.Experimental = !lib.paranoid; }
          (lib.mkIf sys.hardened {
            General = {
              PairableTimeout = 30;
              DiscoverableTimeout = 30;
              MaxControllers = 1;
              TemporaryTimeout = 0;
            };
            Policy.AutoEnable = false;
          })
          (lib.mkIf sys.paranoid { Policy.Privacy = "network/on"; })
        ];
      };
      # hardware.pulseaudio.enable = true;
      # services.blueman.enable = true;
      # enables using headset buttons to control media player
      systemd.user.services.mpris-proxy = lib.mkIf (!sys.paranoid) {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };

      environment.persistence =
        lib.mkIf config.m.fs.disko.root.impermanence.enable {
          "/nix/persist".directories =
            [ "/var/lib/bluetooth" "/etc/bluetooth" ];
        };
    })
    (mkIf (!cfg.bluetooth && sys.hardened) {
      hardware.bluetooth.enable = false;
      environment = {
        persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
          # do i need this at all if it's in the nix store?
          "/nix/persist".files =
            [ "/etc/modprobe.d/nm-disable-bluetooth.conf" ];
        };
        etc."modprobe.d/nm-disable-bluetooth.conf" = {
          text = ''
            install bluetooth /usr/bin/disabled-bluetooth-by-security-misc
            install bluetooth_6lowpan  /usr/bin/disabled-bluetooth-by-security-misc
            install bt3c_cs /usr/bin/disabled-bluetooth-by-security-misc
            install btbcm /usr/bin/disabled-bluetooth-by-security-misc
            install btintel /usr/bin/disabled-bluetooth-by-security-misc
            install btmrvl /usr/bin/disabled-bluetooth-by-security-misc
            install btmrvl_sdio /usr/bin/disabled-bluetooth-by-security-misc
            install btmtk /usr/bin/disabled-bluetooth-by-security-misc
            install btmtksdio /usr/bin/disabled-bluetooth-by-security-misc
            install btmtkuart /usr/bin/disabled-bluetooth-by-security-misc
            install btnxpuart /usr/bin/disabled-bluetooth-by-security-misc
            install btqca /usr/bin/disabled-bluetooth-by-security-misc
            install btrsi /usr/bin/disabled-bluetooth-by-security-misc
            install btrtl /usr/bin/disabled-bluetooth-by-security-misc
            install btsdio /usr/bin/disabled-bluetooth-by-security-misc
            install btusb /usr/bin/disabled-bluetooth-by-security-misc
            install virtio_bt /usr/bin/disabled-bluetooth-by-security-misc
          '';
        };
      };
    })
  ]);
}
