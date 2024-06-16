{ lib, ... }:
with lib;
{
  imports = [
    ../../sys
    ./options.nix
  ];
  m.power = {
    enable = mkDefault true;
    performance = mkDefault true;
  };
}
