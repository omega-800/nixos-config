{ inputs, lib, config, pkgs, usr, ... }:
with lib;
let cfg = config.m.devtools;
in {
  options.m.devtools = { enable = mkEnableOption "enables devtools"; };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
    documentation = {
      enable = true;
      dev.enable = true;
      man = {
        enable = true;
        generateCaches = true;
        man-db.enable = true;
      };
      nixos = {
        enable = true;
        includeAllModules = true;
      };
    };
    environment.systemPackages =
      if usr.extraBloat then
        [ inputs.zen-browser.packages."${pkgs.system}".default ]
      else
        [ ];
  };
}
