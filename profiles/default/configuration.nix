{ lib, ... }:
with lib;
{
  imports = [
    ../../sys
    ./conf.nix
  ];
  m.power = {
    enable = mkDefault true;
    performance = mkDefault true;
  };
}
