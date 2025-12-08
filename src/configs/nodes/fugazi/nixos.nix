{
  imports = [
    ./hardware-configuration.nix
  ];

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
