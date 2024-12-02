{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.u.wm.wayland;
in
{
  # eh maybe someday but for now i'll just use dunst
  config = mkIf (false && cfg.enable) {
    services.swaync = {
      enable = true;
      settings = {
        # https://github.com/ErikReider/SwayNotificationCenter/blob/main/src/configSchema.json
        positionX = "center";
        positionY = "top";
        layer = "overlay";
        layer-shell = true;
        cssPriority = "application";
        control-center-positionX = "right";
        control-center-positionY = "bottom";
        control-center-layer = "top";
        control-center-margin-top = 0;
        control-center-margin-bottom = 0;
        control-center-margin-right = 0;
        control-center-margin-left = 0;
        notification-2fa-action = true;
        # NOTE: Replying in popup notifications is only available if the compositor supports GTK Layer-Shell ON_DEMAND keyboard interactivity.
        notification-inline-replies = false;
        notification-icon-size = 64;
        notification-body-image-height = 100;
        notification-body-image-width = 200;
        # notification-window-width = 500;
        # fit-to-screen = true;
        timeout = 10;
        timeout-low = 5;
        timeout-critical = 0;
      };
      # themeing gets done by stylix
    };
  };
}
