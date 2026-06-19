{
  pkgs,
  lib,
  usr,
  config,
  ...
}:
let
  cfg = config.u.io.fcitx5;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.u.io.fcitx5.enable = mkEnableOption "fcitx5";
  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = usr.wmType == "wayland";
        settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "de";
          };
          "Groups/0/Items/0".Name = "keyboard-de";
        };
      };
    };
  };
}
