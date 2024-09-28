{ config, lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # for building the system remotely (because pi's RAM isn't enough)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11";
}
