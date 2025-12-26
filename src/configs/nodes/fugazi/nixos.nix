{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # TODO: implement for all
  programs.firejail.enable = true;
  # TODO: figure out why this doesn't do jack
  boot = {
    kernelParams = [ "kernel.unprivileged_userns_clone=1" ];
    # huh
    kernel.sysctl."kernel.unprivileged_userns_clone" = lib.mkForce "1";
  };
  security = {
    allowUserNamespaces = true;
    unprivilegedUsernsClone = true;
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
