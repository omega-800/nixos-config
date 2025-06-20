{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.u.work;
  eclipsePkgs = pkgs
  /*
    import (builtins.fetchGit {
      name = "nixos-unstable-eclipse";
      url = "https://github.com/nixos/nixpkgs/";
      ref = "refs/heads/nixos-unstable";
      rev = "69973a9a20858b467dd936542c63554f3675e02d";
    }) { inherit (sys) system; }
  */
  ;
in
{
  options.u.work.eclipse.enable = mkOption {
    description = "enables eclipse";
    type = types.bool;
    default = config.u.work.enable;
  };

  config = mkIf cfg.enable {
    programs.eclipse = {
      enable = true;
      package = eclipsePkgs.eclipses.eclipse-jee;
      enableLombok = true;
      jvmArgs = [
        "-Xmx512m"
        "-ea"
        "-Djava.awt.headless=true"
      ];
      plugins = with eclipsePkgs.eclipses.plugins; [
        vrapper
        freemarker
      ];
    };
  };
}
