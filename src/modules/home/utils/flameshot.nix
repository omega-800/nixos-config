{
  globals,
  lib,
  usr,
  config,
  ...
}:
let
  inherit (lib) mkOption mkIf types;
  cfg = config.u.utils.flameshot;
in
{
  options.u.utils.flameshot.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;
      settings = {
        General = with config.lib.stylix.colors; {
          disabledGrimWarning = true;
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = globals.envVars.SCREENSHOTS_DIR;
          uiColor = "#${base0E}";
          contrastUiColor = "#${base0D}";
          drawColor = "#${base0B}";
          autoCloseIdleDaemon = true;
          allowMultipleGuiInstances = true;
          savePathFixed = true;
          filenamePattern = "%F_%H-%M";
          useGrimAdapter = usr.wmType == "wayland";
        };
      };
    };
  };
}
