{ lib, pkgs, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  #TODO: encryption ssh
  #https://nixos.wiki/wiki/ZFS
  # FIXME: ???
  # m.os.boot.mode = "uefi";
  system.stateVersion = "24.05";
}