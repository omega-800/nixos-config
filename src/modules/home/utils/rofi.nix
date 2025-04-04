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
      package = mkIf (usr.wmType == "wayland") pkgs.rofi-wayland;
      cycle = false;
      extraConfig = {
        modi =
          "drun,run,ssh,window,combi,keys,filebrowser,calc"
          # huh
          + (optionalString (usr.wmType != "wayland") ",windowcd")
          + (optionalString usr.extraBloat ",emoji,top,file-browser-extended");
        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
      };
      font = "${usr.font} 12";
      location = "center";
      pass = {
        enable = true;
        stores = [ globals.envVars.PASSWORD_STORE_DIR ];
        inherit (config.programs.password-store) package;
        #pkgs.pass.withExtensions (exts: with exts; [ pass-checkup pass-otp ]);
      };
      plugins =
        with pkgs;
        [ rofi-calc ]
        ++ (optionals usr.extraBloat (
          with pkgs;
          [
            rofi-emoji
            rofi-top
            rofi-file-browser
          ]
        ));
      terminal = "${pkgs.${usr.term}}/bin/${usr.term}";

      /*
        theme = ''
        * {
          background:     #${config.lib.stylix.colors.base00};
          background-alt: #${config.lib.stylix.colors.base03};
          foreground:     #${config.lib.stylix.colors.base07};
          selected:       #${config.lib.stylix.colors.base0E};
          active:         #${config.lib.stylix.colors.base0B};
          urgent:         #${config.lib.stylix.colors.base09};
          font:           "${usr.font}";
          }

          configuration {
                                     	modi:                       "drun";
          show-icons:                 true;
          display-drun:               "";
                                     	drun-display-format:        "{name}";
          }

          window {
          transparency:                "real";
          location:                    center;
          anchor:                      center;
          fullscreen:                  false;
          width:                       400px;
          x-offset:                    0px;
          y-offset:                    0px;

          enabled:                     true;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          cursor:                      "default";
          }

          mainbox {
          enabled:                     true;
          spacing:                     0px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px 0px 0px 0px;
          border-color:                @selected;
          background-color:            transparent;
          children:                    [ "inputbar", "listview" ];
          }

          inputbar {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     15px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            @selected;
          text-color:                  @background;
          children:                    [ "prompt", "entry" ];
          }

          prompt {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
          }
          textbox-prompt-colon {
          enabled:                     true;
          expand:                      false;
          str:                         "::";
          background-color:            inherit;
          text-color:                  inherit;
          }
          entry {
          enabled:                     true;
          background-color:            inherit;
          text-color:                  inherit;
          cursor:                      text;
          placeholder:                 "Search...";
          placeholder-color:           inherit;
          }

          listview {
          enabled:                     true;
          columns:                     1;
          lines:                       6;
          cycle:                       true;
          dynamic:                     true;
          scrollbar:                   false;
          layout:                      vertical;
          reverse:                     false;
          fixed-height:                true;
          fixed-columns:               true;

          spacing:                     5px;
          margin:                      0px;
          padding:                     0px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      "default";
          }
          scrollbar {
          handle-width:                5px ;
          handle-color:                @selected;
          border-radius:               0px;
          background-color:            @background-alt;
          }

          element {
          enabled:                     true;
          spacing:                     10px;
          margin:                      0px;
          padding:                     8px;
          border:                      0px solid;
          border-radius:               0px;
          border-color:                @selected;
          background-color:            transparent;
          text-color:                  @foreground;
          cursor:                      pointer;
          }
          element normal.normal {
          background-color:            @background;
          text-color:                  @foreground;
          }
          element selected.normal {
          background-color:            @background-alt;
          text-color:                  @foreground;
          }
          element-icon {
          background-color:            transparent;
          text-color:                  inherit;
          size:                        32px;
          cursor:                      inherit;
          }
          element-text {
          background-color:            transparent;
          text-color:                  inherit;
          highlight:                   inherit;
          cursor:                      inherit;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          }

          error-message {
          padding:                     15px;
          border:                      2px solid;
          border-radius:               12px;
          border-color:                @selected;
          background-color:            @background;
          text-color:                  @foreground;
          }
          textbox {
          background-color:            @background;
          text-color:                  @foreground;
          vertical-align:              0.5;
          horizontal-align:            0.0;
          highlight:                   none;
          }
          '';
      */
    };
  };
}
