{
  usr,
  pkgs,
  sys,
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
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

  nix = {
    package = pkgs.nix;
    settings = {
      trusted-users = [
        "root"
        "@wheel"
        usr.username
      ];
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.config.allowUnfree = mkDefault true;
  targets.genericLinux.enable = sys.genericLinux;
  programs.home-manager.enable = mkDefault true;
  home = {
    inherit (usr) username;
    homeDirectory = "${usr.homeDir}";
    preferXdgDirectories = true;

    sessionVariables = mkDefault {
      LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
  };
}
