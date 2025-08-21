{
  lib,
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
    programs.adb.enable = true;
    users.users.${usr.username}.extraGroups = [
      "adbusers"
      "kvm"
    ];
  };
}
