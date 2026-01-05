{
  inputs,
  config,
  lib,
  pkgs,
  sys,
  usr,
  ...
}:
let
  lock_cmd = "pidof hyprlock || hyprlock";
  suspend_cmd = "pidof steam || systemctl suspend || loginctl suspend"; # fuck nvidia
  inherit (lib)
    mkOption
    mkIf
    types
    mkDefault
    ;
  cfg = config.u.wm.hyprland;
in
{
  options.u.wm.hyprland.enable = mkOption {
    type = types.bool;
    default = usr.wm == "hyprland";
  };
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      plugins = [
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprtrails
        # inputs.hycov.packages.${pkgs.system}.hycov
      ];
      xwayland.enable = true;
      systemd.enable = true;
      settings = {
        "windowrulev2" = "suppressevent maximize, class:.*";
        gestures = {
          workspace_swipe = true;
        };
        input = {
          kb_layout = "ch";
          kb_variant = "de";
          repeat_delay = 300;
          repeat_rate = 50;
          follow_mouse = 0;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
            clickfinger_behavior = true;
            scroll_factor = 0.5;
          };
        };
        exec-once = config.u.wm.wayland.autoStart;
        bind = [
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "ALT,R,submap,resize"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          "$mod, M, togglespecialworkspace, magic"
          "$mod SHIFT, M, movetoworkspace, special:magic"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ];
        binde = [
          "$mod Control_L,L,resizeactive,10 1"
          "$mod Control_L,H,resizeactive,-10 0"
          "$mod Control_L,K,resizeactive,0 -10"
          "$mod Control_L,J,resizeactive,0 10"
        ];
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
      };
      submaps = {
        resize = {
          settings = {
            binde = [
              ",right,resizeactive,10 0"
              ",left,resizeactive,-10 0"
              ",up,resizeactive,0 -10"
              ",down,resizeactive,0 10"

              ",L,resizeactive,10 0"
              ",H,resizeactive,-10 0"
              ",K,resizeactive,0 -10"
              ",J,resizeactive,0 10"
            ];
            bind = [
              ",escape,submap,reset"
            ];
          };
        };
      };
    };
  };
}
