{
  sys,
  usr,
  config,
  pkgs,
  lib,
  ...
}:
let
  volumeScript = "${pkgs.writeScript "volume_control" (
    builtins.readFile ../../utils/scripts/volume.sh
  )}";
  backlightScript = "${pkgs.writeScript "brightness_control" (
    builtins.readFile ../../utils/scripts/backlight.sh
  )}";
  screensScript = "${pkgs.writeScript "screens_control" (
    builtins.readFile ../../utils/scripts/home.sh
  )}";
  sxhkdHelperScript = "${pkgs.writeScript "sxhkd_helper" (
    builtins.readFile ../../utils/scripts/sxhkd_helper.sh
  )}";
  super = config.wayland.windowManager.sway.config.modifier;
in
lib.mapAttrs (n: v: "exec ${v}") {
  "${super}+y" = "${pkgs.screenkey}/bin/screenkey &";
  "${super}+Mod1+y" = "pkill -f screenkey";
  "${super}+Shift+r" = ''bash -c "pkill -f sxhkd; sxhkd & dunstify 'sxhkd' 'Reloaded keybindings' -t 500"'';
  "${super}+Shift+h" = sxhkdHelperScript;
  # flameshot & disown solves the copy issue
  "${super}+Shift+s" = "${if sys.genericLinux then "" else "flameshot & disown && "}flameshot gui";
  "${super}+Ctrl+Shift+s" = "flameshot screen";
  "${super}+Mod1+Shift+s" = "flameshot full";
  "${super}+Return " = usr.term;

  # Show clipmenu
  "Mod1+v" = ''
    CM_LAUNCHER=rofi clipmenu \
                  -location 1 \
                  -m -3 \
                  -no-show-icons \
                  -theme-str "* \{ font: 10px; \}" \
                  -theme-str "listview \{ spacing: 0; \}" \
                  -theme-str "window \{ width: 20em; \}"'';

  "XF86AudioMute" = "${volumeScript} mute";
  "XF86AudioRaiseVolume" = "${volumeScript} raise";
  "XF86AudioLowerVolume" = "${volumeScript} lower";

  "XF86MonBrightnessDown" = "${backlightScript} lower";
  "XF86MonBrightnessUp" = "${backlightScript} raise";
  "XF86Display" = "${screensScript}";
  "XF86PowerOff" = "slock";
  # "${super}+s ; r ; {s,h}" = "{nixos-rebuild,home-manager} switch --flake ${NIXOS_CONFIG}#${net.hostname}";
}
