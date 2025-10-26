{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.u.media;
  inherit (pkgs) nixGL;
in
{
  options.u.media.enable = mkEnableOption "media packages";

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      mime.enable = true;
      # echo $XDG_DATA_DIRS | tr -d '\n' | xargs -d : -I % find %/applications -name '*.desktop' | sed -E 's/.*\///g'
      mimeApps =
        let
          defaultApplications = {
            "x-scheme-handler/http" = [ "${usr.browser}.desktop" ];
            "x-scheme-handler/https" = [ "${usr.browser}.desktop" ];
            "text/html" = [ "${usr.browser}.desktop" ];
            "application/pdf" = [
              "org.pwmt.zathura.desktop"
              "${usr.browser}.desktop"
            ];
            "image/png" = [
              "feh.desktop"
              "${usr.browser}.desktop"
            ];
            "image/jpg" = [
              "feh.desktop"
              "${usr.browser}.desktop"
            ];
            "image/svg+xml" = [
              "feh.desktop"
              "${usr.browser}.desktop"
              "inkscape.desktop"
            ];
          };
        in
        {
          enable = true;
          inherit defaultApplications;
          associations = {
            removed = {
              "application/pdf" = [ "chromium-browser.desktop" ];
              "image/png" = [ "chromium-browser.desktop" ];
            };
            added = defaultApplications;
          };
        };
    };
    home.packages =
      with pkgs;
      (
        if !usr.minimal then
          [
            bluez
            bluez-tools
            (nixGL mpv)
            bk
            jmtpfs
          ]
        else
          [ ]
      )
      ++ (
        if usr.extraBloat then
          [
            (nixGL ani-cli)
            krita
            ffmpeg
            imagemagick
            pavucontrol
            schismtracker
          ]
        else
          [ ]
      );
    home.file.".profile".text = mkIf (!usr.minimal) "[ ! -s ~/.config/mpd/pid ] && mpd";
    programs = mkIf usr.extraBloat {
      ncspot = {
        enable = true;
        /*
          package = pkgs.ncspot.override {
            # withNcurses = true;
            withCover = true;
            withShareSelection = true;
          };
        */
        settings = {
          use_nerdfont = true;
          notify = true;
          repeat = "playlist";
          keybindings = {
            "Ctrl+d" = "move down 15";
            "Ctrl+u" = "move up 15";
          };
          statusbar_format = "%artists - %title [%album]";
          track_format = {
            left = "%artists - %title";
            center = "[%album]";
            right = "%saved %duration";
          };
          notification_format = {
            title = "%title [%album]";
            body = "%artists";
          };
        };
      };
      zathura = {
        enable = true;
        extraConfig = ''
          set selection-clipboard clipboard
          map gf exec firefox\ "$FILE"
        '';
      };
    };
  };
}
