{
  globals,
  config,
  pkgs,
  usr,
  lib,
  ...
}:
let
  inherit (pkgs) nixGL;
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  inherit (config.lib.stylix.colors) base00 base0D base03;
  cfg = config.u.wm.river;
in
{
  options.u.wm.river.enable = mkOption {
    type = types.bool;
    default = usr.wm == "river";
  };

  imports = [
    ./yambar.nix
    ./sandbar.nix
  ];

  config = mkIf cfg.enable {
    home.packages = [ pkgs.swaybg ];

    wayland.windowManager.river = {
      enable = true;
      package = nixGL pkgs.river-classic;
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        background-color = "0x${base00}";
        border-color-focused = "0x${base0D}";
        border-color-unfocused = "0x${base03}";
        border-width = 2;
        set-repeat = "50 300";
        default-layout = "rivertile";
        keyboard-layout = "ch";
        set-cursor-warp = "on-output-change";
        input."'*'" = {
          "accel-profile" = "flat";
          "tap" = "enabled";
          "click-method" = "button-areas";
          "scroll-method" = "two-finger";
        };
        declare-mode = [ "passthrough" ];
        map-pointer.normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
          "Super BTN_MIDDLE" = "toggle-float";
        };
        map = {
          normal = {
            "Super Return" = "spawn ${usr.term}";
            "Super Q" = "close";
            "Super+Shift Q" = "exit";
            "Super J" = "focus-view next";
            "Super K" = "focus-view previous";
            "Super+Shift J" = "swap next";
            "Super+Shift K" = "swap previous";
            "Super Period" = "focus-output next";
            "Super Comma" = "focus-output previous";
            "Super+Shift Period" = "send-to-output next";
            "Super+Shift Comma" = "send-to-output previous";
            "Super+Shift Return" = "zoom";
            "Super H" = ''send-layout-cmd rivertile "main-ratio -0.05"'';
            "Super L" = ''send-layout-cmd rivertile "main-ratio +0.05"'';
            "Super I" = ''send-layout-cmd rivertile "main-count +1"'';
            "Super D" = ''send-layout-cmd rivertile "main-count -1"'';
            "Super+Alt H" = "move left 100";
            "Super+Alt J" = "move down 100";
            "Super+Alt K" = "move up 100";
            "Super+Alt L" = "move right 100";
            "Super+Alt+Control H" = "snap left";
            "puper+Alt+Control J" = "snap down";
            "Super+Alt+Control K" = "snap up";
            "Super+Alt+Control L" = "snap right";
            "Super+Alt+Shift H" = "resize horizontal -100";
            "Super+Alt+Shift J" = "resize vertical 100";
            "Super+Alt+Shift K" = "resize vertical -100";
            "Super+Alt+Shift L" = "resize horizontal 100";
            "Super Space" = "toggle-float";
            "Super F" = "toggle-fullscreen";
            "Super Up" = ''send-layout-cmd rivertile "main-location top"'';
            "Super Right" = ''send-layout-cmd rivertile "main-location right"'';
            "Super Down" = ''send-layout-cmd rivertile "main-location bottom"'';
            "Super Left" = ''send-layout-cmd rivertile "main-location left"'';
            "Super F11" = "enter-mode passthrough";
          };
          passthrough = {
            "Super F11" = "enter-mode normal";
          };
        };
        spawn = [
          "'nohup ${pkgs.sway-audio-idle-inhibit} &'"
          "'swaybg --image ${config.stylix.image} --mode fill'"
          "'${pkgs.writeShellScript "notify-bat" ../sway/notify-bat.sh}'"
          "yambar"
          "'${usr.term} -e tmux a'"
          "${globals.envVars.XDG_CONFIG_HOME}/river/bar"
          "${globals.envVars.XDG_CONFIG_HOME}/river/status"
        ];
      };
      extraConfig = builtins.readFile ./init;
    };
  };
}
