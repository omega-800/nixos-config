{ usr, ... }:
{
  imports = [
    ./sh
    ./nixGL
    ./generic
    ./wm
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
    ./io
    ./custom
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
    usr.username
  ];
}
