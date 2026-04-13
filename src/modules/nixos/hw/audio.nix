{
  sys,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.m.hw.audio;
  inherit (lib) mkEnableOption mkIf mkMerge;
in
{
  options.m.hw.audio = {
    enable = mkEnableOption "audio";
    pipewire = mkEnableOption "pipewire, pulseaudio otherwise";
    bluetooth = mkEnableOption "bluetooth";
  };

  config = mkIf cfg.enable (mkMerge [
    (
      if sys.stable then
        {
          hardware.pulseaudio.enable = !cfg.pipewire;
        }
      else
        {
          services.pulseaudio.enable = !cfg.pipewire;
        }
    )
    {
      security.rtkit.enable = cfg.pipewire;

      services = {
        pipewire =
          if cfg.pipewire then
            {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
              jack.enable = false;
              wireplumber = {
                enable = true;
                extraConfig = {
                  "20-bluez" = {
                    "monitor.bluez.properties" = {
                      "bluez5.enable-sbc-xq" = true;
                      "bluez5.enable-msbc" = true;
                      "bluez5.enable-hw-volume" = true;
                      "bluez5.roles" = [
                        "a2dp_sink"
                        "a2dp_source"
                      ];
                    };
                    "11-bluetooth-policy" = {
                      "wireplumber.settings" = {
                        "bluetooth.autoswitch-to-headset-profile" = false;
                      };
                    };
                  };
                };
              };
            }
          else
            {
              enable = false;
            };
      };
    }
    (mkIf cfg.bluetooth {

      # desperation
      environment.systemPackages = with pkgs; [
        bluez-tools

        pavucontrol
        pulseaudio
      ];
      # boot.kernelModules = [
      #   "btusb"
      #   "btintel"
      # ];
      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            ControllerMode = "dual";
            Experimental = !sys.paranoid;
            FastConnectable = true;
            # Enable = "Source,Sink,Media,Socket,Headset";
          };
          Policy = {
            AutoEnable = true;
          };
        };
      };
      services.pulseaudio = {
        package = pkgs.pulseaudioFull;
        configFile = pkgs.writeText "default.pa" ''
          load-module module-bluetooth-policy
          load-module module-bluetooth-discover
          ## module fails to load with 
          ##   module-bluez5-device.c: Failed to get device path from module arguments
          ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
          # load-module module-bluez5-device
          # load-module module-bluez5-discover
        '';
      };
      # enables using headset buttons to control media player
      systemd.user.services.mpris-proxy = lib.mkIf (!sys.paranoid) {
        description = "Mpris proxy";
        after = [
          "network.target"
          "sound.target"
        ];
        wantedBy = [ "default.target" ];
        serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
      };

      environment.persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
        "/nix/persist".directories = [
          "/var/lib/bluetooth"
          "/etc/bluetooth"
        ];
      };
    })
    # (mkIf (!cfg.bluetooth && sys.hardened) {
    #   hardware.bluetooth.enable = false;
    #   environment = {
    #     persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
    #       # do i need this at all if it's in the nix store?
    #       "/nix/persist".files =
    #         [ "/etc/modprobe.d/nm-disable-bluetooth.conf" ];
    #     };
    #     etc."modprobe.d/nm-disable-bluetooth.conf" = {
    #       text = ''
    #         install bluetooth /usr/bin/disabled-bluetooth-by-security-misc
    #         install bluetooth_6lowpan  /usr/bin/disabled-bluetooth-by-security-misc
    #         install bt3c_cs /usr/bin/disabled-bluetooth-by-security-misc
    #         install btbcm /usr/bin/disabled-bluetooth-by-security-misc
    #         install btintel /usr/bin/disabled-bluetooth-by-security-misc
    #         install btmrvl /usr/bin/disabled-bluetooth-by-security-misc
    #         install btmrvl_sdio /usr/bin/disabled-bluetooth-by-security-misc
    #         install btmtk /usr/bin/disabled-bluetooth-by-security-misc
    #         install btmtksdio /usr/bin/disabled-bluetooth-by-security-misc
    #         install btmtkuart /usr/bin/disabled-bluetooth-by-security-misc
    #         install btnxpuart /usr/bin/disabled-bluetooth-by-security-misc
    #         install btqca /usr/bin/disabled-bluetooth-by-security-misc
    #         install btrsi /usr/bin/disabled-bluetooth-by-security-misc
    #         install btrtl /usr/bin/disabled-bluetooth-by-security-misc
    #         install btsdio /usr/bin/disabled-bluetooth-by-security-misc
    #         install btusb /usr/bin/disabled-bluetooth-by-security-misc
    #         install virtio_bt /usr/bin/disabled-bluetooth-by-security-misc
    #       '';
    #     };
    #   };
    # })
  ]);
}
