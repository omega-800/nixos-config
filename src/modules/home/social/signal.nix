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
    home.packages = with pkgs; [ signal-cli siggy ] ++ (lib.optionals usr.extraBloat [ signal-desktop ]);
    home.sessionVariables.SIGGY_IMAGE_PROTOCOL = "kitty siggy";
    xdg.configFile."siggy/config.toml" = {
      enable = true;
      force = true;
      text = ''
        account = "+41772156436"
        download_dir = "${globals.envVars.XDG_DOWNLOAD_DIR}/siggy"
        notify_direct = true
        notify_group = true
        desktop_notifications = true
        inline_images = true
        mouse_enabled = false
        send_read_receipts = true
        notification_preview = "full"
        clipboard_clear_seconds = 60
        lock_timeout = 0
        image_mode = "native"
        image_max_width = 40
        preview_image_max_width = 30
        image_max_height = 30
        sixel_max_colors = 256
        sixel_diffusion = 0.875
        show_link_previews = true
        date_separators = true
        show_receipts = true
        color_receipts = true
        nerd_fonts = true
        emoji_to_text = false
        show_reactions = true
        reaction_verbose = false
        sidebar_on_right = false
        theme = "Gruvbox Dark"
        keybinding_profile = "Default"
        settings_profile = "Default"
      '';
    };
  };
}
