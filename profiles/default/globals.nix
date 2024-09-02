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

    WORKSPACE_DIR = "$HOME/ws";
    SCREENSHOTS_DIR = (builtins.replaceStrings [ "$HOME" ] [ "${usr.homeDir}" ]
      XDG_PICTURES_DIR) + "/screenshots";

    HISTFILE = lib.mkForce "$XDG_STATE_HOME/shell/history";
    PASSWORD_STORE_DIR = lib.mkForce "$XDG_DATA_HOME/pass";
    GNUPGHOME = lib.mkForce "$XDG_DATA_HOME/gnupg";
    GOPATH = lib.mkForce "$XDG_DATA_HOME/go";
    GOBIN = lib.mkForce "$XDG_BIN_HOME/go";
    GTK2_RC_FILES = lib.mkForce "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    IPYTHONDIR = lib.mkForce "$XDG_CONFIG_HOME/ipython";
    PYTHONSTARTUP = lib.mkForce "$XDG_CONFIG_HOME/python/pythonrc";
    JUPYTER_CONFIG_DIR = lib.mkForce "$XDG_CONFIG_HOME/jupyter";
    XCURSOR_PATH = lib.mkForce "/usr/share/icons:$XDG_DATA_HOME/icons";
    XINITRC = lib.mkForce "$XDG_CONFIG_HOME/X11/xinitrc";
    ZDOTDIR = lib.mkForce "$XDG_CONFIG_HOME/zsh";
    XAUTHORITY = lib.mkForce "$XDG_RUNTIME_DIR/Xauthority";

    # uuuuuuuuuuuuuuuuuhhhh wHy Am I gEtTiNg `CoMmAnD nOt FoUnD` eRrOrS
    # fixed this with `. /etc/set-environment`
    # and prepending $PATH to the value, duh
    PATH = "$PATH:${XDG_BIN_HOME}";
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
