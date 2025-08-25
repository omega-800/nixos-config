{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.posix;
in
{
  options.u.posix.enable = mkEnableOption "posix shell";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dash
      shellcheck
    ];
  };
}
