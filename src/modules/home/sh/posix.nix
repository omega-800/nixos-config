{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
with lib;
let
  cfg = config.u.posix;
in
{
  options.u.posix = {
    enable = mkEnableOption "enables posix shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dash
      shellcheck
    ];
  };
}
