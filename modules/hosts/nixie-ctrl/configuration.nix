{ lib, pkgs, ... }: {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

	m.boot.mode = "bios";
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11"; 
services.unifi = {
enable = true;
unifiPackage = pkgs.unifi8;
};
}
