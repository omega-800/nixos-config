{
  inputs,
  config,
  sys,
  lib,
  pkgs,
  usr,
  ...
}:
let
  cfg = config.m.wm.wayland;
  inherit (lib)
    mkOption
    types
    mkIf
    mkMerge
    ;
in
{
  options.m.wm.wayland = {
    enable = mkOption {
      description = "enables wayland";
      type = types.bool;
      default = usr.wmType == "wayland";
    };
  };
  config = mkIf cfg.enable {

    # aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [
    #     xdg-desktop-portal-gnome
    #     xdg-desktop-portal-gtk
    #     xdg-desktop-portal-wlr
    #   ];
    #   xdgOpenUsePortal = true;
    #   wlr.enable = true;
    # };

    # https://github.com/NixOS/nixpkgs/issues/91218
    # services.dbus.packages = with pkgs; [
    #   xdg-desktop-portal-wlr
    # ];
    # environment.variables = {
    #   XDG_DESKTOP_PORTAL_DIR = pkgs.symlinkJoin {
    #     name = "xdg-portals";
    #     paths = [ pkgs.xdg-desktop-portal-wlr ];
    #   } + "/share/xdg-desktop-portal/portals";
    # };
    # aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaahhhhhhhhhhhh

    environment.systemPackages = with pkgs; [
      # why do i need this again?
      wayland
      # apparently this i definitely need
      # apparently not if it's commented out
      # can you tell that i know what i'm doing
      # lxqt.lxqt-policykit
    ];
  };
}
