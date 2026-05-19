{
  config,
  lib,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.dunst;
in
{
  options.u.utils.dunst.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    services.dunst = with config.lib.stylix.colors.withHashtag; {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          # frame_color = base0E;
          # highlight = base0D;
          origin = "top-center";
          offset = "0x50";
          notification_limit = 20;
          progress_bar = true;
          icon_corner_radius = 0;
          indicate_hidden = "yes";
          transparency = 10;
          sort = "yes";
          idle_threshold = 240;
          line_height = 0;
          markup = "full";
          format = "<b>%s</b> %b %p";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          icon_position = "left";
          sticky_history = "yes";
          history_length = 20;
          ignore_dbusclose = false;
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };
        urgency_low = {
          # foreground = base05;
          # highlight = base0B;
          timeout = 5;
        };
        urgency_normal = {
          timeout = 10;
        };
        urgency_critical = {
          # highlight = base09;
          timeout = 50;
        };
      };
    };
  };
}
