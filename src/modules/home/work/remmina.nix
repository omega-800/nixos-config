{
  lib,
  config,
  pkgs,
  home,
  ...
}:
let
  cfg = config.u.work.remmina;
  inherit (lib) mkOption mkIf types;
in
{
  options.u.work.remmina = {
    enable = mkOption {
      description = "enables remmina";
      type = types.bool;
      default = config.u.work.enable;
    };
  };

  config = mkIf cfg.enable {
    services.remmina = {
      enable = true;
    };
  };
}
