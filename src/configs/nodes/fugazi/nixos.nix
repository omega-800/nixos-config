{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: multiple profiles + specialisations

  m = {
    sw.steam.enable = true;
    dev.docker.enable = true;
  };
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
