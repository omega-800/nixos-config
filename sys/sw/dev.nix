{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.devtools;
in {
  options.m.devtools = {
    enable = mkEnableOption "enables devtools";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;
  };
}
