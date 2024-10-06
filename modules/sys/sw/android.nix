{ lib, pkgs, config, usr, ... }:
with lib;
let cfg = config.m.sw.android;
in {
  options.m.sw.android.enable = mkOption {
    description = "enables android tools";
    type = types.bool;
    default = config.m.sw.enable;
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${usr.username}.extraGroups = [ "adbusers" ];
    environment.defaultPackages = with pkgs; [ universal-android-debloater ];
  };
}
