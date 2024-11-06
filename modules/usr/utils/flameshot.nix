{
  globals,
  lib,
  usr,
  config,
  ...
}:
with lib;
let
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
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
          savePath = globals.envVars.SCREENSHOTS_DIR;
          uiColor = "#${base0E}";
          contrastUiColor = "#${base0D}";
          drawColor = "#${base0B}";
          # does this prevent copying?
          # nope
          autoCloseIdleDaemon = true;
          allowMultipleGuiInstances = true;
          savePathFixed = true;
          filenamePattern = "%F_%H-%M";
        };
      };
    };
  };
}
