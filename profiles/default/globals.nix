{ usr, pkgs, lib, ... }: {
  envVars = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";

    XDG_DESKTOP_DIR = "$HOME/desk";
    XDG_DOCUMENTS_DIR = "$HOME/doc";
    XDG_DOWNLOAD_DIR = "$HOME/dl";
    XDG_MUSIC_DIR = "${XDG_DOCUMENTS_DIR}/music";
    XDG_PICTURES_DIR = "${XDG_DOCUMENTS_DIR}/img";
    XDG_PUBLICSHARE_DIR = "${XDG_DOCUMENTS_DIR}/share";
    XDG_TEMPLATES_DIR = "${XDG_DOCUMENTS_DIR}/templ";
    XDG_VIDEOS_DIR = "${XDG_DOCUMENTS_DIR}/vid";

    PATH = "${XDG_BIN_HOME}";
    EDITOR = usr.editor;
  };
  styling =
    let
      themePath = ./. + "../../../../themes/${usr.theme}";
      themeYamlPath = themePath + "/${usr.theme}.yaml";
      themePolarity =
        lib.removeSuffix "\n" (builtins.readFile (themePath + "/polarity.txt"));
      themeImage =
        if builtins.pathExists (themePath + "/${usr.theme}.png") then
          themePath + "/${usr.theme}.png"
        else
          pkgs.fetchurl {
            url = builtins.readFile (themePath + "/backgroundurl.txt");
            sha256 = builtins.readFile (themePath + "/backgroundsha256.txt");
          };
      myLightDMTheme =
        if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
    in
    rec {
      base16Scheme = themeYamlPath;
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };
      polarity = themePolarity;
      image = themeImage;
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
      };
    };
}
