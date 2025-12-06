{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  m.sw.steam.enable = true;
  system.stateVersion = "25.11";
}
