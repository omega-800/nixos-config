{ lib, ... }:
{
  imports = [
    ./tools.nix
    ./docker.nix
    ./mysql.nix
    ./virt.nix
    ./orchestration.nix
  ];
}
