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
    home = {
      sessionVariables = {
        MOZ_ENABLE_WAYLAND = 1;
        QT_AUTO_SCREEN_SCALE_FACTOR = 1;
        QT_ENABLE_HIGHDPI_SCALING = 1;
      };
      packages =
        with pkgs;
        [
          xdg-desktop-portal
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
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
              xdg-desktop-portal
            ]
          else
            [ ]
        );
    };
    services = {
      cliphist = {
        enable = true;
        allowImages = true;
        systemdTarget = "graphical-session.target";
      };
      kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
      };
      swhkd = {
        # still can't get it to work
        enable = false;
        keybindings =
          let
            volumeScript = "${pkgs.writeScript "volume_control" (
              builtins.readFile ../../utils/scripts/volume.sh
            )}";
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