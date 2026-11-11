{
  globals,
  config,
  pkgs,
  usr,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.mattermost;
  pinnedNixpkgs = import (fetchGit {
    name = "nixpkgs_matterhorn";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "bbcdf758d61b6095693d00dea8a75061bf89b264";
    shallow = true;
  }) { inherit (pkgs.stdenv.hostPlatform) system; };
in
{
  options.u.social.mattermost.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    home.packages = [ pinnedNixpkgs.matterhorn ];
    xdg.configFile."matterhorn/config.ini".text = ''
      [mattermost]
      user = omega
      host = chat.coredump.ch
      passcmd = pass school/coredump-mattermost
    '';
  };
}
