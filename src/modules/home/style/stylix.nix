{
  config,
  usr,
  lib,
  pkgs,
  inputs,
  PATHS,
  ...
}:
let
  themePath = PATHS.THEMES + /${usr.theme};
  themeYamlPath = themePath + /${usr.theme}.yaml;
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (themePath + /polarity.txt));
  themeImage =
    if builtins.pathExists (themePath + /${usr.theme}.png) then
      themePath + /${usr.theme}.png
    else
      pkgs.fetchurl {
        url = builtins.readFile (themePath + /backgroundurl.txt);
        sha256 = builtins.readFile (themePath + /backgroundsha256.txt);
      };
in
{
  imports = if usr.style then [ inputs.stylix.homeManagerModules.stylix ] else [ ];
  config =
    if !usr.style then
      { }
    else
      lib.mkMerge [
        (
          if usr.minimal then
            { }
          else
            {
              u.x11.initExtra = "feh --no-fehbg --bg-fill ${config.stylix.image}";
            }
        )
        ({
          fonts.fontconfig.enable = true;
          home.packages =
            with pkgs;
            [
              (nerdfonts.override {
                fonts =
                  [ "JetBrainsMono" ]
                  ++ (
                    if usr.extraBloat then
                      [
                        "FiraCode"
                        "FiraMono"
                        "Hack"
                        "Hasklig"
                        "Ubuntu"
                        "UbuntuMono"
                        "CascadiaCode"
                        "CodeNewRoman"
                        "FantasqueSansMono"
                        "Iosevka"
                        "ShareTechMono"
                        "Hermit"
                      ]
                    else
                      [ ]
                  );
              })
            ]
            ++ (
              if usr.extraBloat then
                [
                  noto-fonts
                  noto-fonts-cjk-sans
                  noto-fonts-emoji
                  noto-fonts-monochrome-emoji
                ]
              else
                [ ]
            );
          home.file = with config.lib.stylix.colors; {
            ".config/.currenttheme".text = usr.theme;
            ".config/.currentcolors.conf".text = ''
              base00 = #${base00}
              base01 = #${base01}
              base02 = #${base02}
              base03 = #${base03}
              base04 = #${base04}
              base05 = #${base05}
              base06 = #${base06}
              base07 = #${base07}
              base08 = #${base08}
              base09 = #${base09}
              base0A = #${base0A}
              base0B = #${base0B}
              base0C = #${base0C}
              base0D = #${base0D}
              base0E = #${base0E}
              base0F = #${base0F}
            '';
          };
          stylix = {
            enable = true;
            autoEnable = true;
            opacity.terminal = 0.85;
            base16Scheme = themeYamlPath;
            cursor = lib.mkIf (!usr.minimal) {
              package = pkgs.bibata-cursors;
              name = "Bibata-Modern-Ice";
              size = 32;
            };
            polarity = themePolarity;
            # image = themeImage;
            image = pkgs.fetchurl {
              url = builtins.readFile ("${themePath}/backgroundurl.txt");
              sha256 = builtins.readFile ("${themePath}/backgroundsha256.txt");
            };

            fonts = {
              monospace = {
                name = usr.font;
                package = usr.fontPkg;
              };
              serif = {
                name = usr.font;
                package = usr.fontPkg;
              };
              sansSerif = {
                name = usr.font;
                package = usr.fontPkg;
              };
              emoji = lib.mkIf (!usr.minimal) {
                name = "Noto Color Emoji";
                package = pkgs.noto-fonts-emoji-blob-bin;
              };
              sizes = {
                terminal = 18;
                applications = 12;
                popups = 12;
                desktop = 12;
              };
            };

            targets = {
              alacritty.enable = true;
              bat.enable = true;
              kde.enable = true;
              yazi.enable = true;
              kitty.enable = true;
              #gtk.enable = true;
              rofi.enable = (usr.wmType == "x11");
              feh.enable = (usr.wmType == "x11");
              sxiv.enable = false;
              xfce.enable = true;
              nixvim.enable = true;
              vim.enable = true;
              vscode.enable = true;
              waybar.enable = true;
              wezterm.enable = true;
              xresources.enable = (usr.wmType == "x11");
              dunst.enable = true;
              fzf.enable = true;
              hyprland.enable = true;
              qutebrowser.enable = true;
              tmux.enable = true;
              zathura.enable = true;
              sway.enable = true;
              swaylock = {
                enable = true;
                useImage = true;
              };
              firefox = {
                enable = true;
                profileNames = [ usr.username ];
              };
            };
          };
          #    font.size = config.stylix.fonts.sizes.terminal;
          #    programs.alacritty.settings = {
          #      colors = {
          #      # TODO revisit these color mappings
          #      # these are just the default provided from stylix
          #      # but declared directly due to alacritty v3.0 breakage
          #      primary.background = "#"+config.lib.stylix.colors.base00;
          #      primary.foreground = "#"+config.lib.stylix.colors.base07;
          #      cursor.text = "#"+config.lib.stylix.colors.base00;
          #      cursor.cursor = "#"+config.lib.stylix.colors.base07;
          #      normal.black = "#"+config.lib.stylix.colors.base00;
          #      normal.red = "#"+config.lib.stylix.colors.base08;
          #      normal.green = "#"+config.lib.stylix.colors.base0B;
          #      normal.yellow = "#"+config.lib.stylix.colors.base0A;
          #      normal.blue = "#"+config.lib.stylix.colors.base0D;
          #      normal.magenta = "#"+config.lib.stylix.colors.base0E;
          #      normal.cyan = "#"+config.lib.stylix.colors.base0B;
          #      normal.white = "#"+config.lib.stylix.colors.base05;
          #      bright.black = "#"+config.lib.stylix.colors.base03;
          #      bright.red = "#"+config.lib.stylix.colors.base09;
          #      bright.green = "#"+config.lib.stylix.colors.base01;
          #      bright.yellow = "#"+config.lib.stylix.colors.base02;
          #      bright.blue = "#"+config.lib.stylix.colors.base04;
          #      bright.magenta = "#"+config.lib.stylix.colors.base06;
          #      bright.cyan = "#"+config.lib.stylix.colors.base0F;
          #      bright.white = "#"+config.lib.stylix.colors.base07;
          #    };
          #  };
          # home.file.".fehbg-stylix".text = ''
          #   #!/bin/sh
          #   feh --no-fehbg --bg-fill '' + config.stylix.image + ''
          #   ;
          # '';
          # home.file.".fehbg-stylix".executable = true;
          # home.file.".swaybg-stylix".text = ''
          #   #!/bin/sh
          #     swaybg -m fill -i '' + config.stylix.image + ''
          #   ;
          # '';
          # home.file.".swaybg-stylix".executable = true;
          # home.file.".swayidle-stylix".text = ''
          #   #!/bin/sh
          #     swaylock_cmd='swaylock --indicator-radius 200 --screenshots --effect-blur 10x10'
          #     swayidle -w timeout 300 "$swaylock_cmd --fade-in 0.5 --grace 5" \
          #             timeout 600 'hyprctl dispatch dpms off' \
          #             resume 'hyprctl dispatch dpms on' \
          #             before-sleep "$swaylock_cmd"
          # '';
          # home.file.".swayidle-stylix".executable = true;
          # home.file = {
          #   ".config/qt5ct/colors/oomox-current.conf".source =
          #     config.lib.stylix.colors {
          #       template = builtins.readFile ./oomox-current.conf.mustache;
          #       extension = ".conf";
          #     };
          #   ".config/Trolltech.conf".source = config.lib.stylix.colors {
          #     template = builtins.readFile ./Trolltech.conf.mustache;
          #     extension = ".conf";
          #   };
          #   ".config/kdeglobals".source = config.lib.stylix.colors {
          #     template = builtins.readFile ./Trolltech.conf.mustache;
          #     extension = "";
          #   };
          #   ".config/qt5ct/qt5ct.conf".text =
          #     pkgs.lib.mkBefore (builtins.readFile ./qt5ct.conf);
          # };
          # home.file.".config/hypr/hyprpaper.conf".text = "preload = "
          #   + config.stylix.image + ''
          #
          #     wallpaper = eDP-1,'' + config.stylix.image + ''
          #
          #       wallpaper = HDMI-A-1,'' + config.stylix.image + ''
          #
          #         wallpaper = DP-1,'' + config.stylix.image + "";
        })
      ];
}
