{ config, lib, usr, ... }: with lib; {
  services.dunst = mkIf config.u.utils.enable {
    enable = true;
    configFile = ./dunstrc;
    settings = {
      global = {
        follow = "keyboard";
        frame_color = "#"+config.lib.stylix.colors.base0E;
        highlight = "#"+config.lib.stylix.colors.base0D;
        #font = "${usr.font} 10";
        #icon_theme = "${usr.font} 10";
      };
      urgency_low = {
        #background = "#"+config.lib.stylix.colors.base00;
        foreground = "#"+config.lib.stylix.colors.base05;        
        highlight = "#"+config.lib.stylix.colors.base0B;
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
        highlight = "#"+config.lib.stylix.colors.base09;
        #frame_color = "#"+config.lib.stylix.colors.base06;
        timeout = 50;
      };
    };
  };
}
