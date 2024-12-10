{
  sys,
  usr,
  config,
  pkgs,
  lib,
  ...
}:
let
  super = config.wayland.windowManager.sway.config.modifier;
in
{
  "${super}+Mod1+h" = "resize shrink width 10 px";
  "${super}+Mod1+j" = "resize grow height 10 px";
  "${super}+Mod1+k" = "resize shrink height 10 px";
  "${super}+Mod1+l" = "resize grow width 10 px";
  "${super}+q" = "kill";
  "${super}+Shift+q" = "exit";

  "${super}+h" = "focus left";
  "${super}+j" = "focus down";
  "${super}+k" = "focus up";
  "${super}+l" = "focus right";

  "${super}+Left" = "focus left";
  "${super}+Down" = "focus down";
  "${super}+Up" = "focus up";
  "${super}+Right" = "focus right";

  "${super}+Shift+h" = "move left";
  "${super}+Shift+j" = "move down";
  "${super}+Shift+k" = "move up";
  "${super}+Shift+l" = "move right";

  "${super}+Shift+Left" = "move left";
  "${super}+Shift+Down" = "move down";
  "${super}+Shift+Up" = "move up";
  "${super}+Shift+Right" = "move right";

  "${super}+b" = "splith";
  "${super}+v" = "splitv";
  "${super}+f" = "fullscreen toggle";
  "${super}+a" = "focus parent";

  "${super}+t" = "layout stacking";
  "${super}+w" = "layout tabbed";
  "${super}+e" = "layout toggle split";

  "${super}+Shift+space" = "floating toggle";
  "${super}+space" = "focus mode_toggle";

  "${super}+1" = "workspace number 1";
  "${super}+2" = "workspace number 2";
  "${super}+3" = "workspace number 3";
  "${super}+4" = "workspace number 4";
  "${super}+5" = "workspace number 5";
  "${super}+6" = "workspace number 6";
  "${super}+7" = "workspace number 7";
  "${super}+8" = "workspace number 8";
  "${super}+9" = "workspace number 9";
  "${super}+0" = "workspace number 10";

  "${super}+Shift+1" = "move container to workspace number 1";
  "${super}+Shift+2" = "move container to workspace number 2";
  "${super}+Shift+3" = "move container to workspace number 3";
  "${super}+Shift+4" = "move container to workspace number 4";
  "${super}+Shift+5" = "move container to workspace number 5";
  "${super}+Shift+6" = "move container to workspace number 6";
  "${super}+Shift+7" = "move container to workspace number 7";
  "${super}+Shift+8" = "move container to workspace number 8";
  "${super}+Shift+9" = "move container to workspace number 9";
  "${super}+Shift+0" = "move container to workspace number 10";

  "${super}+Shift+minus" = "move scratchpad";
  "${super}+minus" = "scratchpad show";

  "${super}+Shift+c" = "reload";
  "${super}+Shift+e" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

  "${super}+Shift+r" = "mode resize";

  "XF86PowerOff" = "exec ${pkgs.swaylock}/bin/swaylock -fF";
  "${super} x" = "exec ${pkgs.swaylock}/bin/swaylock -fF";
}
