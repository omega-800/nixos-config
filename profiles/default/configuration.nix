{ lib, ... }:
with lib;
{
  imports = [
    ../../sys
  ];
  m.power = {
    enable = mkDefault true;
    performance = mkDefault true;
  };
}
