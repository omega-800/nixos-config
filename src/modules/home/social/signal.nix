{
  globals,
  config,
  usr,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkIf
    ;
  cfg = config.u.social.signal;
in
{
  options.u.social.signal.enable = mkOption {
    type = types.bool;
    default = config.u.social.enable;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ siggy ] ++ (lib.optionals usr.extraBloat [ signal-desktop ]);
    home.sessionVariables.SIGGY_IMAGE_PROTOCOL = "kitty siggy";
    xdg.configFile."siggy/config.toml" = {
      enable = true;
      force = true;
      text = ''
        download_dir = "${globals.envVars.XDG_DOWNLOAD_DIR}/siggy"
        notify_direct = true
        notify_group = true
        desktop_notifications = true
        inline_images = true
        mouse_enabled = false
        send_read_receipts = true
      '';
    };
  };
}
