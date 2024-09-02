{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  hardware.enableRedistributableFirmware = true;
  config.m.boot.bootMode = "ext";

  system.stateVersion = "22.05"; 
  #system.stateVersion = "23.11"; 
}

