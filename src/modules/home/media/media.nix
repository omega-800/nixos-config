{
  usr,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf optionals;
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
              "com.github.xournalpp.xournalpp.desktop"
              "${usr.browser}.desktop"
            ];
            "application/x-xopp" = [
              "com.github.xournalpp.xournalpp.desktop"
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
      (optionals (!usr.minimal) [
        bluez
        bluez-tools
        bk
        adbfs-rootless
        pavucontrol
      ])
      ++ (optionals usr.extraBloat [
        (nixGL ani-cli)
        krita
        ffmpeg
        imagemagick
        schismtracker
      ]);
  };
}
