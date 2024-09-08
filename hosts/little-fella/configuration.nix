{ lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m.boot = { mode = "uefi"; };
  system.stateVersion = "24.05";
}
