{ config, usr, lib, pkgs, inputs, ... }:
let
  themePath = "../../../../themes"+("/"+usr.theme+"/"+usr.theme)+".yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../../themes"+("/"+usr.theme)+"/polarity.txt"));
  backgroundUrl = builtins.readFile (./. + "../../../../themes"+("/"+usr.theme)+"/backgroundurl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../../themes/"+("/"+usr.theme)+"/backgroundsha256.txt");
in
  {
    imports = if usr.style then [ inputs.stylix.homeManagerModules.stylix ] else [];
    config = lib.mkIf usr.style {
      fonts.fontconfig.enable = true;
      home.packages = with pkgs; [

      (nerdfonts.override { fonts = [ "CascadiaCode" "CodeNewRoman" "FantasqueSansMono" "Iosevka" "ShareTechMono" "Hermit" "JetBrainsMono" "FiraCode" "FiraMono" "Hack" "Hasklig" "Ubuntu" "UbuntuMono" ]; })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      ];
    home.file = {
      ".currenttheme".text = usr.theme;
      ".currentcolors.conf".text = ''
        base00 = #${config.lib.stylix.colors.base00}
        base01 = #${config.lib.stylix.colors.base01}
        base02 = #${config.lib.stylix.colors.base02}
        base03 = #${config.lib.stylix.colors.base03}
        base04 = #${config.lib.stylix.colors.base04}
        base05 = #${config.lib.stylix.colors.base05}
        base06 = #${config.lib.stylix.colors.base06}
        base07 = #${config.lib.stylix.colors.base07}
        base08 = #${config.lib.stylix.colors.base08}
        base09 = #${config.lib.stylix.colors.base09}
        base0A = #${config.lib.stylix.colors.base0A}
        base0B = #${config.lib.stylix.colors.base0B}
        base0C = #${config.lib.stylix.colors.base0C}
        base0D = #${config.lib.stylix.colors.base0D}
        base0E = #${config.lib.stylix.colors.base0E}
        base0F = #${config.lib.stylix.colors.base0F}
      '';
    };
    stylix = {
      autoEnable = true;
      base16Scheme = ./. + themePath;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };
      polarity = themePolarity;
      image = pkgs.fetchurl {
        url = backgroundUrl;
        sha256 = backgroundSha256;
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
        emoji = {
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
        alacritty.enable = false;
        bat.enable = false;
        kde.enable = true;
        kitty.enable = true;
        gtk.enable = true;
        rofi.enable = (usr.wmType == "x11");
        feh.enable = (usr.wmType == "x11");
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
        firefox = {
          enable = true;
          profileNames = [ usr.username ];
        };
      };
    };
    programs.feh.enable = true;
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
  home.file.".fehbg-stylix".text = ''
    #!/bin/sh
    feh --no-fehbg --bg-fill ''+config.stylix.image+'';
    '';
  home.file.".fehbg-stylix".executable = true;
  home.file.".swaybg-stylix".text = ''
  #!/bin/sh
    swaybg -m fill -i ''+config.stylix.image+'';
    '';
  home.file.".swaybg-stylix".executable = true;
  home.file.".swayidle-stylix".text = ''
  #!/bin/sh
    swaylock_cmd='swaylock --indicator-radius 200 --screenshots --effect-blur 10x10'
    swayidle -w timeout 300 "$swaylock_cmd --fade-in 0.5 --grace 5" \
            timeout 600 'hyprctl dispatch dpms off' \
            resume 'hyprctl dispatch dpms on' \
            before-sleep "$swaylock_cmd"
  '';
  home.file.".swayidle-stylix".executable = true;
  home.file = {
    ".config/qt5ct/colors/oomox-current.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./oomox-current.conf.mustache;
      extension = ".conf";
    };
    ".config/Trolltech.conf".source = config.lib.stylix.colors {
      template = builtins.readFile ./Trolltech.conf.mustache;
      extension = ".conf";
    };
    ".config/kdeglobals".source = config.lib.stylix.colors {
      template = builtins.readFile ./Trolltech.conf.mustache;
      extension = "";
    };
    ".config/qt5ct/qt5ct.conf".text = pkgs.lib.mkBefore (builtins.readFile ./qt5ct.conf);
  };
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ''+config.stylix.image+''

    wallpaper = eDP-1,''+config.stylix.image+''

    wallpaper = HDMI-A-1,''+config.stylix.image+''

    wallpaper = DP-1,''+config.stylix.image+''
    '';
  };
  }
