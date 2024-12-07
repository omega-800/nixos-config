{
  usr,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.utils.sxhkd;
in
{
  options.u.utils.sxhkd.enable = mkOption {
    type = types.bool;
    default = config.u.utils.enable && !usr.minimal && usr.wmType == "x11";
  };

  config = mkIf cfg.enable {
    services.sxhkd = {
      enable = true;
      keybindings = {
        "{super + x,XF86PowerOff}" = "slock";
        "super + s ; x ; h" = "xrandr --output HDMI-1 --auto --left-of eDP-1";
        "super + s ; k ; {c,u,r}" = "setxkbmap -layout {ch -variant de,us,ru}";
        "super + shift + r" = ''bash -c "pkill -f sxhkd; sxhkd & dunstify 'sxhkd' 'Reloaded keybindings' -t 500"'';
      };
    };
  };
}
