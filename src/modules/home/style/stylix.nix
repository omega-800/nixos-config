{
  config,
  usr,
  sys,
  lib,
  pkgs,
  inputs,
  globals,
  ...
}:
let
  inherit (lib) optionalAttrs optionals;
in
{
  # FIXME: colors wrong after stylix update
  imports = if usr.style then [ inputs.stylix.homeManagerModules.stylix ] else [ ];
  config =
    if !usr.style then
      { }
    else
      lib.mkMerge [
        (optionalAttrs (!usr.minimal) {
          u.wm.x11.initExtra = "feh --no-fehbg --bg-fill ${config.stylix.image}";
        })
        {
          fonts.fontconfig.enable = true;
          home = {
      packages =
            with pkgs;
            [ nerd-fonts.jetbrains-mono ]
            ++ (optionals usr.extraBloat [
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-monochrome-emoji
            ]);
          file = {
            ".config/currenttheme/image".source = globals.styling.image;
            ".config/currenttheme/theme.conf".text = ''
              name = ${usr.theme}
              polarity = ${globals.styling.polarity}
              font = ${usr.font}
            '';
            ".config/currenttheme/colors.conf".text = lib.concatMapAttrsStringSep "\n" (
              n: v: "${n} = #${v}"
            ) globals.styling.colors;
          };
          };
          stylix = {
            enable = true;
            autoEnable = true;
            opacity.terminal = 0.85;
            base16Scheme = globals.styling.colors;
            inherit (globals.styling)
              icons
              cursor
              polarity
              image
              fonts
              ;

            targets = {
              alacritty.enable = true;
              bat.enable = true;
              kde.enable = true;
              yazi.enable = true;
              kitty.enable = true;
              gtk.enable = true;
              rofi.enable = true;
              feh.enable = true;
              sxiv.enable = false;
              xfce.enable = true;
              nixvim = {
                enable = true;
                transparentBackground = {
                  main = true;
                  signColumn = true;
                };
              };
              vim.enable = true;
              vscode = {
                profileNames = [ "default" ];
                enable = true;
              };
              waybar.enable = true;
              wezterm.enable = true;
              # xresources.enable = true; TODO: disable?
              dunst.enable = true;
              fzf.enable = true;
              hyprland.enable = true;
              qutebrowser.enable = true;
              tmux.enable = true;
              zathura.enable = true;
              sway.enable = true;
              swaylock = {
                enable = true;
                useWallpaper = true;
              };
              firefox = {
                enable = true;
                profileNames = [ usr.username ];
              };
            };
          };
        xresources.properties = with config.lib.stylix.colors.withHashtag; {
          "*foreground" = base05;
          "*background" = base00;
          "*cursorColor" = base05;
          "*color0" = base00;
          "*color1" = base08;
          "*color2" = base0B;
          "*color3" = base0A;
          "*color4" = base0D;
          "*color5" = base0E;
          "*color6" = base0C;
          "*color7" = base05;

          # "*color8" = base02;
          # "*color9" = base08;
          # "*color10" = base0B;
          # "*color11" = base0A;
          # "*color12" = base0D;
          # "*color13" = base0E;
          # "*color14" = base0C;
          "*color8" =  base03;
          "*color9" =  base09;
          "*color10" = base01;
          "*color11" = base02;
          "*color12" = base04;
          "*color13" = base06;
          "*color14" = base0F;

          "*color15" = base07;
          "*color16" = base09;
          "*color17" = base0F;
          "*color18" = base01;
          "*color19" = base02;
          "*color20" = base04;
          "*color21" = base06;
          "*.faceName" = globals.styling.fonts.monospace.name;
          "*.faceSize" = toString globals.styling.fonts.sizes.terminal;
          "*.renderFont" = true;
        };
        }
      ];
}
