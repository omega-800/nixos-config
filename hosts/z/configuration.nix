{ lib, pkgs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11"; 
}

