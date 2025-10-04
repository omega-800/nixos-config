{ config, lib, ... }:
let
  inherit (lib) mkIf;
  inherit (config.lib.stylix) fonts colors;
  cfg = config.u.wm.river;
in
{
  config = mkIf (false && cfg.enable) {
    xdg.configFile."yambar/config.yml".source = ./yambar.yml;
    programs.yambar = {
      enable = true;
      # settings = {
      #   bar = {
      #     location = "top";
      #     height = 26;
      #     foreground = colors.base06;
      #     background = colors.base01;
      #     font = fonts.monospace.name;
      #     spacing = 2;
      #     margin = 0;
      #     layer = "bottom";
      #
      #     left = [
      #       {
      #         river = {
      #           anchors = [
      #             {
      #               base = {
      #                 left-margin = 10;
      #                 right-margin = 10;
      #                 default.string.text = "";
      #               };
      #             }
      #           ];
      #
      #           title.string.text = "{seat} - {title} ({layout}/{mode})";
      #
      #           content.map = {
      #
      #           };
      #         };
      #       }
      #     ];
      #
      #     right = [
      #       {
      #         clock.content = [
      #           {
      #             string.text = "{time}";
      #           }
      #         ];
      #       }
      #     ];
      #   };
      # };
    };
  };
}
