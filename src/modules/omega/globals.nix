{
  usr,
  pkgs,
  lib,
  PATHS,
  ...
}:
{
  envVars = rec {
    HOME = usr.homeDir;
    BROWSER = usr.browser;
    XDG_CACHE_HOME = "${HOME}/.cache";
    XDG_CONFIG_HOME = "${HOME}/.config";
    XDG_DATA_HOME = "${HOME}/.local/share";
    XDG_STATE_HOME = "${HOME}/.local/state";
    XDG_BIN_HOME = "${HOME}/.local/bin";
    XDG_RUNTIME_DIR = "/run/user/$(id -u)";

    XDG_DESKTOP_DIR = "${HOME}/desk";
    XDG_DOCUMENTS_DIR = "${HOME}/doc";
    XDG_DOWNLOAD_DIR = "${HOME}/dl";
    XDG_MUSIC_DIR = "${MEDIA_DIR}/music";
    XDG_PICTURES_DIR = "${MEDIA_DIR}/img";
    XDG_VIDEOS_DIR = "${MEDIA_DIR}/vid";
    XDG_PUBLICSHARE_DIR = "${MISC_DIR}/share";
    XDG_TEMPLATES_DIR = "${MISC_DIR}/templ";

    MEDIA_DIR = "${XDG_DOCUMENTS_DIR}/media";
    MISC_DIR = "${XDG_DOCUMENTS_DIR}/misc";
    GTK2_RC_FILES = lib.mkForce "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
    XCURSOR_PATH = lib.mkForce "$XCURSOR_PATH\${XCURSOR_PATH:+:}${HOME}/.nix-profile/share/icons:/usr/share/icons:/usr/share/pixmaps:${XDG_DATA_HOME}/icons";
    WORKSPACE_DIR = "${HOME}/ws";
    NIXOS_CONFIG = "${WORKSPACE_DIR}/nixos-config";

    SCRIPTS_DIR = "${WORKSPACE_DIR}/scripts";
    SCREENSHOTS_DIR = "${XDG_PICTURES_DIR}/screenshots";
    SHELLDIR = "${XDG_STATE_HOME}/shell";
    HISTFILE = "${SHELLDIR}/history";
    PASSWORD_STORE_DIR = "${XDG_DATA_HOME}/pass";
    GNUPGHOME = lib.mkForce "${XDG_DATA_HOME}/gnupg";
    GOPATH = "${XDG_DATA_HOME}/go";
    GOBIN = "${XDG_BIN_HOME}/go";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
    PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    XINITRC = "${XDG_CONFIG_HOME}/X11/xinitrc";
    ZDOTDIR = "${XDG_CONFIG_HOME}/zsh";
    ZCOMPDUMP = ''${XDG_CACHE_HOME}/zsh/zcompdump-"$ZSH_VERSION"'';
    XAUTHORITY = "${XDG_RUNTIME_DIR}/Xauthority";
    XRESOURCES = "${XDG_CONFIG_HOME}/X11/xresources";
    TMUX_PLUGIN_MANAGER_PATH = "${XDG_DATA_HOME}/tmux/plugins";
    QT_QPA_PLATFORMTHEME = "qt5ct";

    #GVIMINIT = ''let $MYGVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/gvimrc" : "$XDG_CONFIG_HOME/nvim/init.gvim" | so $MYGVIMRC'';
    #VIMINIT = ''let $MYVIMRC = !has("nvim") ? "$XDG_CONFIG_HOME/vim/vimrc" :  "$XDG_CONFIG_HOME/nvim/init.vim" | so $MYVIMRC'';

    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    NPM_PREFIX = "${XDG_DATA_HOME}/npm";
    NPM_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_INIT_MODULE = "${XDG_CONFIG_HOME}/npm/config/npm-init.js";
    NPM_TMP = "${XDG_RUNTIME_DIR}/npm";

    SSH_ASKPASS = "";
    GIT_ASKPASS = "";
    # uuuuuuuuuuuuuuuuuhhhh wHy Am I gEtTiNg `CoMmAnD nOt FoUnD` eRrOrS
    # fixed this with `. /etc/set-environment`
    # and prepending $PATH to the value, duh
    PATH = "$PATH:${XDG_BIN_HOME}";
    EDITOR = usr.editor;
  };
  sshConfig = {
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "diffie-hellman-group-exchange-sha256"
      "sntrup761x25519-sha512@openssh.com"
    ];
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
    ciphers = [
      "aes256-ctr"
      "aes192-ctr"
      "aes128-ctr"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "rsa-sha2-512"
      "rsa-sha2-256"
    ];
  };
  styling =
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
      myLightDMTheme = if themePolarity == "light" then "Adwaita" else "Adwaita-dark";
    in
    {
      base16Scheme = themeYamlPath;
      cursor = lib.mkIf (!usr.minimal) {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 32;
      };
      polarity = themePolarity;
      image = themeImage;
      fonts = rec {
        monospace = {
          name = usr.font;
          package = usr.fontPkg;
        };
        serif = monospace;
        sansSerif = serif;
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
    };
}
