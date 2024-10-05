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
        powerOnBoot = true;
        # enables showing battery charge of devices
        settings.General.Experimental = true;
      };
      # hardware.pulseaudio.enable = true;
      # services.blueman.enable = true;
      # enables using headset buttons to vontrol media player
      systemd.user.services.mpris-proxy = {
        description = "Mpris proxy";
        after = [ "network.target" "sound.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };

      environment.persistence =
        lib.mkIf config.m.fs.disko.root.impermanence.enable {
          "/nix/persist".directories = [ "/var/lib/bluetooth" ];
        };
    })
  ]);
}
