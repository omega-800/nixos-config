{
  sys,
  pkgs,
  config,
  lib,
  usr,
  ...
}:
let
  cfg = config.u.wm.wayland;
  inherit (lib)
    optionals
    mkOption
    mkIf
    types
    elem
    mkDefault
    ;
in
{
  imports = [
    ./i3status.nix
    ./waybar.nix
    ./swhkd.nix
    ./swaync.nix
    ./swayidle.nix
    ./swaylock.nix
    ./gammastep.nix
    ./kanshi.nix
    ./wpaperd.nix
  ];
  options.u.wm.wayland = {
    enable = mkOption {
      type = types.bool;
      default = usr.wmType == "wayland";
    };
    autoStart = mkOption {
      type = types.listOf types.lines;
      default =
        (optionals (!usr.minimal) [
          "swaybg --image ${config.stylix.image} --mode fill"
        ])
        ++ (optionals (!sys.stationary) [
          "nohup ${pkgs.sway-audio-idle-inhibit} &"
          "${pkgs.notify_bat}"
        ])
        ++ [
          "${usr.term} -e tmux a"
          # "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=wlroots"
          "wl-clip-persist --clipboard regular --reconnect-tries 0 &"
          "wl-paste --type text --watch cliphist store &"
          # "echo 'Xft.dpi: 140' | xrdb -merge"
          # "gsettings set org.gnome.desktop.interface text-scaling-factor 1.4"
          # "/usr/lib/xfce-polkit/xfce-polkit &"
        ];
    };
  };
  config = mkIf cfg.enable {
    # https://github.com/riverwm/river/wiki/Home/74c4da7d3a6fe55856baaa5d8261b95cf568cd85#how-do-i-disable-gtk-decorations-eg-title-bar
    gtk.gtk3.extraCss = ''
      /* No (default) titlebar on wayland */
      headerbar.titlebar.default-decoration {
        background: transparent;
        padding: 0;
        margin: 0 0 -17px 0;
        border: 0;
        min-height: 0;
        font-size: 0;
        box-shadow: none;
      }

      /* rm -rf window shadows */
      window.csd,             /* gtk4? */
      window.csd decoration { /* gtk3 */
        box-shadow: none;
      }
    '';

    xdg.portal = {
      enable = true;
      # xdgOpenUsePortal = true;
      config = {
        common = {
          default = [ "gtk" "wlr" "gnome" ];
          "org.freedesktop.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
    home = {
      sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        QT_ENABLE_HIGHDPI_SCALING = 1;
        WAYLAND_DISPLAY = "wayland-1";
      };
      # TODO: clean this up
      packages =
        with pkgs;
        [
          sway-audio-idle-inhibit
          xdg-utils
          grim
          slurp
          wl-clipboard
          wf-recorder
        ]
        ++ (optionals sys.genericLinux (
          with pkgs;
          [
            lxqt.lxqt-policykit
            xwayland
          ]
        ));
    };
    services = {
      cliphist = {
        enable = true;
        allowImages = true;
        systemdTargets = "graphical-session.target";
      };
    };
  };
}
