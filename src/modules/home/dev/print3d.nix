{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types mkIf mkOption;
  cfg = config.u.dev.print3d;
in
{
  options.u.dev.print3d.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prusa-slicer
      openscad
      freecad
    ];
  };
}
