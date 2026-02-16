{
  lib,
  pkgs,
  config,
  usr,
  ...
}:
let
  cfg = config.m.dev.android;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.dev.android.enable = mkEnableOption "android devtools";

  config = mkIf cfg.enable {
    users.users.${usr.username}.extraGroups = [
      "adbusers"
      "kvm"
    ];
    environment.defaultPackages = with pkgs; [ universal-android-debloater android-tools ];
  };
}
