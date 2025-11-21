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
          home.packages =
            with pkgs;
            [ nerd-fonts.jetbrains-mono ]
            ++ (optionals usr.extraBloat [
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-monochrome-emoji
            ])
            ++ (optionals (sys.profile == "school") [ fira-math ]);
          home.file = {
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
              xresources.enable = true;
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
        }
      ];
}
