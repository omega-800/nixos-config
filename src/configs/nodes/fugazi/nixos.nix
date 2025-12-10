{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: multiple profiles + specialisations

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };
  users = {
    extraGroups.wireshark = { };
    users.omega.extraGroups = [
      "wireshark"
      "docker"
    ];
  };
  m = {
    sw.steam.enable = true;
    dev.docker.enable = true;
  };

  # TODO: end

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      videoAcceleration = true;
      modesetting.enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
