{ lib, pkgs, config, usr, ... }:
let
  cfg = config.m.sw.android;
  inherit (lib) mkEnableOption mkIf;
in {
  options.m.sw.android.enable = mkEnableOption "enables android tools";

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${usr.username}.extraGroups = [ "adbusers" ];
    environment.defaultPackages = with pkgs; [ universal-android-debloater ];
  };
}
