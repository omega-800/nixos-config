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
  inherit (lib)
    mkOption
    mkIf
    types
    ;
  cfg = config.u.wm.niri;
  mk9 = f: lib.mergeAttrsList (lib.genList (n: f (n + 1)) 9);
in
{
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
    inputs.noctalia.homeModules.default
  ];
  options.u.wm.niri.enable = mkOption {
    type = types.bool;
    default = usr.wm == "niri";
  };
  config = mkIf cfg.enable {
    services.swhkd = {
      enable = true;
      inherit (config.services.sxhkd) keybindings;
    };
    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
      settings = {
        spawn-at-startup = [
          { command = [ "noctalia-shell" ]; }
        ]
        ++ (map (c: { command = [ c ]; }) config.u.wm.wayland.autoStart);
        workspaces = mk9 (n: {
          ${toString n} = { };
        });
        prefer-no-csd = true;
        hotkey-overlay.skip-at-startup = true;
        cursor = {
          hide-when-typing = true;
          hide-after-inactive-ms = 1000;
        };
        window-rules = [
          {
            matches = [ { } ];
            geometry-corner-radius = {
              top-left = 20.0;
              top-right = 20.0;
              bottom-left = 20.0;
              bottom-right = 20.0;
            };
            clip-to-geometry = true;
          }
        ];
        input = {
          workspace-auto-back-and-forth = true;
          mod-key = "Super";
          keyboard = {
            repeat-delay = 300;
            repeat-rate = 50;
            xkb = {
              variant = "de";
              layout = "ch";
            };
          };
        };
        binds =
          with config.lib.niri.actions;
          (
            (lib.mapAttrs' (
              k: v:
              lib.nameValuePair (lib.replaceStrings [ "Mod4" " " ] [ "Mod" "+" ] k) {
                action.spawn = [
                  "sh"
                  "-c"
                  v
                ];
              }
            ) (lib.filterAttrs (_: v: !(lib.isAttrs v)) config.scawm.bindings))
            // {
              "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = { };
              "Mod+W".action.toggle-column-tabbed-display = { };
              "Mod+Shift+M".action.show-hotkey-overlay = { };

              "Mod+Shift+Q".action.quit.skip-confirmation = true;
              "Mod+Q".action = close-window;
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+Space".action = toggle-window-floating;

              "Mod+H".action = focus-column-or-monitor-left;
              "Mod+L".action = focus-column-or-monitor-right;
              "Mod+J".action = focus-window-or-workspace-down;
              "Mod+K".action = focus-window-or-workspace-up;

              "Alt+Shift+H".action = consume-or-expel-window-left;
              "Alt+Shift+L".action = consume-or-expel-window-right;

              "Mod+Shift+H".action = move-column-left-or-to-monitor-left;
              "Mod+Shift+L".action = move-column-right-or-to-monitor-right;
              "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
              "Mod+Shift+K".action = move-window-up-or-to-workspace-up;

              "Mod+Alt+H".action = set-column-width "-1%";
              "Mod+Alt+L".action = set-column-width "+1%";
              "Mod+Alt+J".action = set-window-height "-1%";
              "Mod+Alt+K".action = set-window-height "+1%";
              "Mod+Alt+Shift+H".action = set-column-width "-5%";
              "Mod+Alt+Shift+L".action = set-column-width "+5%";
              "Mod+Alt+Shift+J".action = set-window-height "-5%";
              "Mod+Alt+Shift+K".action = set-window-height "+5%";

              # "Mod+Ctrl+Shift+H".action = consume-or-expel-window-left;
              # "Mod+Ctrl+Shift+L".action = consume-or-expel-window-right;
              "Mod+Home".action = focus-column-first;
              "Mod+End".action = focus-column-last;
              "Mod+Shift+Home".action = move-column-to-first;
              "Mod+Shift+End".action = move-column-to-last;

              "Mod+C".action = center-column;
              "Mod+Shift+C".action = center-visible-columns;
              "Mod+R".action = switch-preset-column-width;
              "Mod+Shift+R".action = switch-preset-window-height;
              "Mod+Ctrl+R".action = reset-window-height;

              "Mod+Comma".action = focus-monitor-left;
              "Mod+Period".action = focus-monitor-right;
              "Mod+Shift+Comma".action = move-column-to-monitor-left;
              "Mod+Shift+Period".action = move-column-to-monitor-right;

              "Mod+Return".action.spawn = "kitty";
            }
            // (mk9 (n: {
              "Mod+${toString n}".action = focus-workspace (toString (10 - n));
              "Mod+Shift+${toString n}".action.move-column-to-workspace = toString (10 - n);
            }))
          );
      };
    };
    programs.noctalia-shell = {
      enable = true;
    };
  };
}
