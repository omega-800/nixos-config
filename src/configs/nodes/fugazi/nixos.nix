{
  imports = [
    ./hardware-configuration.nix
  ];

  m.sw.steam.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    enable32Bit = true;
    nvidia = {
      open = true;
      nvidiaSettings = true;
      videoAcceleration = true;
      modesetting.enable = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
