{ usr, ... }: {
  home.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    XDG_BIN_HOME = "$HOME/.local/bin";

    XDG_DESKTOP_DIR = "$HOME/desk";
    XDG_DOCUMENTS_DIR = "$HOME/doc";
    XDG_DOWNLOAD_DIR = "$HOME/dl";
    XDG_MUSIC_DIR = "$HOME/doc/music";
    XDG_PICTURES_DIR = "$HOME/doc/img";
    XDG_PUBLICSHARE_DIR = "$HOME/doc/share";
    XDG_TEMPLATES_DIR = "$HOME/doc/templ";
    XDG_VIDEOS_DIR = "$HOME/doc/vid";

    PATH = "${XDG_BIN_HOME}";
    EDITOR = usr.editor;
  };
}
