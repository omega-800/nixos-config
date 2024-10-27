{ config, usr, pkgs, lib, globals, ... }:

let
  cfg = config.u.wm.pixom;
  inherit (pkgs) nixGL;
  inherit (lib) mkOption mkIf types mkDefault;
  # nixGL = import ../../nixGL/nixGL.nix { inherit config pkgs; };
in
{

  options.u.wm.picom.enable = mkOption {
    type = types.bool;
    default = usr.wmType == "x11";
  };
  config = mkIf cfg.enable {
    services.picom = {
      enable = true;
      package = nixGL pkgs.picom;

      wintypes = {
        tooltip = {
          fade = true;
          shadow = true;
          opacity = 0.9;
          focus = true;
          full-shadow = false;
        };
        dock = {
          shadow = false;
          clip-shadow-above = true;
        };
        dnd = { shadow = false; };
        popup_menu = { opacity = 0.8; };
        dropdown_menu = { opacity = 0.8; };
      };
      activeOpacity = 1.0;
      inactiveOpacity = if usr.wm == "qtile" then 0.8 else 1;
      menuOpacity = 0.8;
      opacityRules = [
        "90:name *= 'st'"
        "90:name *= 'alacritty'"
        "90:name *= 'kitty'"
        "90:name *= 'code'"
        "90:name *= 'Code'"
        "90:name *= 'VSCodium'"
        "100:name *= 'Firefox'"
      ];
      backend = "glx";
      vsync = false;
      fade = true;
      fadeDelta = 10;
      fadeSteps = [ 5.0e-2 5.0e-2 ];
      shadow = true;
      shadowExclude = [
        "name = 'Notification'"
        "class_g = 'Conky'"
        "class_g ?= 'Notify-osd'"
        "class_g = 'Cairo-clock'"
        "_GTK_FRAME_EXTENTS@:c"
      ];
      shadowOffsets = [ -17 -17 ];
      shadowOpacity = 0.8;

      settings = {
        shadow-radius = 16;
        shadow-color = "#000000";
        frame-opacity = 0.9;
        inactive-dim = 0.2;
        focus-exclude = [ "class_g = 'Cairo-clock'" ];
        corner-radius = if usr.wm == "qtile" then 12 else 0;
        rounded-corners-exclude =
          [ "window_type = 'dock'" "window_type = 'desktop'" ];
        blur-method = "dual_kawase";
        blur-size = 10;
        blur-deviation = false;
        blur-strength = 2;
        blur-kern = "3x3box";
        blur-background-exclude = [
          "window_type = 'dock'"
          "window_type = 'desktop'"
          "_GTK_FRAME_EXTENTS@:c"
        ];
        mark-wmwin-focused = false;
        mark-ovredir-focused = false;
        detect-rounded-corners = true;
        detect-client-opacity = true;
        use-ewmh-active-win = false;
        unredir-if-possible = false;
        detect-transient = true;
        detect-client-leader = false;
        glx-no-stencil = true;
        glx-no-rebind-pixmap = false;
        use-damage = true;
        log-level = "warn";
        log-file = "${globals.envVars.XDG_DATA_HOME}/picom/picom.log";
        show-all-xerrors = true;
      };
    };

    home = {
      packages = with pkgs; [ (nixGL picom) ];
      file.".config/picom/picom.conf".source =
        if usr.wm == "dwm" then ./picom_dwm.conf else ./picom.conf;
    };
  };
}
