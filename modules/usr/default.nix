{ usr, ... }:
{
  imports = [
    ./sh
    ./nixGL
    ./generic
    ./wm/picom/picom.nix
    ./dev
    ./style
    ./work
    ./file
    ./media
    ./net
    ./office
    ./social
    ./user
    ./utils
    ./custom
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
    usr.username
  ];
}
