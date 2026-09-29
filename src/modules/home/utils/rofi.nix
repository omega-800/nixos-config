{
  config,
  lib,
  usr,
  pkgs,
  globals,
  ...
}:
let
  cfg = config.u.utils.rofi;
  inherit (lib)
    optionalString
    optionals
    mkOption
    mkForce
    types
    mkIf
    ;
in
{
  options.u.utils.rofi.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal;
  };

  config = mkIf cfg.enable {
    home.file.".config/networkmanager-dmenu/config.ini".text =
      lib.readFile ./networkmanager-dmenu.config.ini;
    home.packages =
      with pkgs;
      (
        [
          rofi-mpd
          rofi-systemd
          rofi-bluetooth
          networkmanager_dmenu
        ]
        ++ (optionals usr.extraBloat [
          rofi-vpn
          rofi-screenshot
          rofi-power-menu
          rofi-pulse-select
        ])
      );
    programs.rofi = {
      enable = true;
      settings = {
        location = "center";
        cycle = false;
        terminal = "${pkgs.${usr.term}}/bin/${usr.term}";
        font = mkForce "${usr.font} 12";
        modi =
          "drun,run,ssh,window,combi,keys,filebrowser,calc"
          # huh
          + (optionalString (usr.wmType != "wayland") ",windowcd");
        # + (optionalString usr.extraBloat ",emoji,top,file-browser-extended");
        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
      };
      plugins =

        with pkgs;
        [ rofi-calc ]
        ++ (optionals usr.extraBloat (
          with pkgs;
          [
            # rofi-emoji
            # rofi-top
            # rofi-file-browser
          ]
        ));
    };
  };
}
