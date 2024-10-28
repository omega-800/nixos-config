{
  usr,
  sys,
  pkgs,
  lib,
  ...
}:
with lib;
{
  imports = [
    ../../usr
  ];
  nix = {
    package = pkgs.nix;
    settings.experimental-features = mkDefault [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = mkDefault true;
  targets.genericLinux.enable = sys.genericLinux;
  programs.home-manager.enable = mkDefault true;
  home = {
    username = usr.username;
    homeDirectory = "${usr.homeDir}";

    sessionVariables = mkDefault {
      LOCALES_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    };

    stateVersion = mkDefault "23.11"; # Please read the comment before changing.
  };
}
