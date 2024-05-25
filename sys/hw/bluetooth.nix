{ ... }: {
  options = {
    mBluetooth.enable = lib.mkEnableOption "enables bluetooth";
  };

  config = lib.mkIf config.mBluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      # enables showing battery charge of devices
      General = {
        Experimental = true;
      };
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
  };
}
