{
  inputs,
  config,
  pkgs,
  lib,
  usr,
  ...
}:
let
  cfg = config.m.wm.niri;
  inherit (lib)
    mkOption
    types
    mkIf
    ;
in
{
  imports = [ inputs.niri.nixosModules.niri ];
  options.m.wm.niri = {
    enable = mkOption {
      description = "enables niri";
      type = types.bool;
      default = usr.wm == "niri";
    };
  };
  config = mkIf cfg.enable {
    niri-flake.cache.enable = true;
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };
}
