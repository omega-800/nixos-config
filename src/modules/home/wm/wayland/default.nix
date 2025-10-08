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
    mkOption
    mkIf
    types
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
  ];
  options.u.wm.wayland.enable = mkOption {
    type = types.bool;
    default = usr.wmType == "wayland";
  };
  config = mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      config = {
        common.default = [ "gtk" ];
        sway = {
          "org.freedesktop.impl.portal.Screencast" = "wlr";
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
          #xdg-mime
          #xdg-open
          #xdg-settings
          grim
          slurp
          wl-clipboard
          wf-recorder
        ]
        ++ (
          if sys.genericLinux then
            with pkgs;
            [
              lxqt.lxqt-policykit
              xwayland
            ]
          else
            [ ]
        );
    };
    services = {
      cliphist = {
        enable = true;
        allowImages = true;
        systemdTargets = "graphical-session.target";
      };
      kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
      };
      /*
        swhkd = {
          # still can't get it to work
          enable = false;
          keybindings =
            let
              volumeScript = "${pkgs.volume_control}";
            in
            {

              "super + shift + s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
              "super + ctrl + shift + s" = "flameshot screen";
              "super + alt + shift + s" = "flameshot full";
              "super + enter " = usr.term;
              "{super + a ; m,XF86AudioMute}" = "${volumeScript} mute";
              "{XF86AudioRaiseVolume,super + a : i}" = "${volumeScript} raise";
              "{XF86AudioLowerVolume,super + a : d}" = "${volumeScript} lower";
            };
        };
      */
    };
    # systemd.user.services.swhkd = {
    #   Service.Type = "simple";
    #   Unit.Description = "simple wayland hotkey daemon";
    #   Install.WantedBy = [ "default.target" ];
    #   Service.ExecStart = "${pkgs.writeShellScript "start-swhkd" ''
    #     #!/usr/bin/env bash
    #     #${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent
    #     lxqt-policykit-agent
    #     pkill -f swhks
    #     swhks & pkexec swhkd;
    #   ''}";
    # };
  };
}
