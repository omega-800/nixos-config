{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "22.05"; 
  #system.stateVersion = "23.11"; 
}
