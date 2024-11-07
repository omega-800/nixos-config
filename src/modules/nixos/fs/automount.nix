{ lib, config, ... }:
let
  cfg = config.m.fs.automount;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.fs.automount.enable = mkEnableOption "enables automount";

  config = mkIf cfg.enable {
    # services.devmon.enable = true;
    # services.gvfs.enable = true;
    services.udisks2 = {
      enable = true;
      mountOnMedia = true;
      settings = {
        "udisks2.conf" = {
          defaults = {
            encryption = "luks2";
          };
          udisks2 = {
            modules = [ "*" ];
            modules_load_preference = "ondemand";
          };
        };
      };
    };
  };
}
