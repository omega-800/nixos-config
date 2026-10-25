{
  usr,
  pkgs,
  sys,
  lib,
  nixosIntegrated ? false,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
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
    package = lib.mkForce pkgs.nix;
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
    # FIXME: unslopify
    username = mkIf (!nixosIntegrated) usr.username;
    homeDirectory = mkIf (!nixosIntegrated) "${usr.homeDir}";
    preferXdgDirectories = true;

    sessionVariables = mkDefault {
      LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };
  };
}
