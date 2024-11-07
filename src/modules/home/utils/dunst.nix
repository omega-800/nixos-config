{
  config,
  lib,
  usr,
  ...
}:
with lib;
let
  cfg = config.u.utils.dunst;
in
{
  options.u.utils.dunst.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "keyboard";
          frame_color = "#" + config.lib.stylix.colors.base0E;
          highlight = "#" + config.lib.stylix.colors.base0D;
          origin = "top-center";
          offset = "0x50";
          #    scale = 0;
          notification_limit = 20;
          progress_bar = true;
          icon_corner_radius = 0;
          indicate_hidden = "yes";
          transparency = 10;
          sort = "yes";
          idle_threshold = 240;
          line_height = 0;
          markup = "full";
          #
          #    # The format of the message.  Possible variables are:
          #    #   %a  appname
          #    #   %s  summary
          #    #   %b  body
          #    #   %i  iconname (including its path)
          #    #   %I  iconname (without its path)
          #    #   %p  progress value if set ([  0%] to [100%]) or nothing
          #    #   %n  progress value if set without any extra characters
          #    #   %%  Literal %
          #    # Markup is allowed
          format = "<b>%s</b> %b %p";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = "no";
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = "yes";
          enable_recursive_icon_lookup = true;
          icon_position = "left";
          sticky_history = "yes";
          history_length = 20;
          #    ### Misc/Advanced ###
          #    dmenu = "/usr/bin/dmenu -p dunst:";
          #    browser = "/usr/bin/xdg-open";
          #    always_run_script = true;
          #    title = "Dunst";
          #    class = "Dunst";
          ignore_dbusclose = false;

          #    # Defines list of actions for each mouse event
          #    # Possible values are:
          #    # * none: Don't do anything.
          #    # * do_action: Invoke the action determined by the action_name rule. If there is no
          #    #              such action, open the context menu.
          #    # * open_url: If the notification has exactly one url, open it. If there are multiple
          #    #             ones, open the context menu.
          #    # * close_current: Close current notification.
          #    # * close_all: Close all notifications.
          #    # * context: Open context menu for the notification.
          #    # * context_all: Open context menu for all notifications.
          #    # These values can be strung together for each mouse event, and
          #    # will be executed in sequence.
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";

          #font = "${usr.font} 10";
          #icon_theme = "${usr.font} 10";
        };
        urgency_low = {
          #background = "#"+config.lib.stylix.colors.base00;
          foreground = "#" + config.lib.stylix.colors.base05;
          highlight = "#" + config.lib.stylix.colors.base0B;
          #frame_color = "#"+config.lib.stylix.colors.base03;
          timeout = 5;
        };
        urgency_normal = {
          #background = "#"+config.lib.stylix.colors.base00;
          #foreground = "#"+config.lib.stylix.colors.base07;        
          timeout = 10;
        };
        urgency_critical = {
          #background = "#"+config.lib.stylix.colors.base00;
          #foreground = "#"+config.lib.stylix.colors.base08;        
          highlight = "#" + config.lib.stylix.colors.base09;
          #frame_color = "#"+config.lib.stylix.colors.base06;
          timeout = 50;
        };
      };
    };
  };
}
