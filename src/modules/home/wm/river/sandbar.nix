{
  globals,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (globals.styling) fonts colors;
  cfg = config.u.wm.river;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (sandbar.overrideAttrs (_: {
        src = fetchFromGitHub {
          owner = "kolunmi";
          repo = "sandbar";
          rev = "51887cee0a2cea8cf0aba2d81442b75403485e1c";
          hash = "sha256-lUiDdmcu/CYe8hEWoUX+bM1cDy/590TvRgfLO6Ry6Vk=";
        };
      }))
    ];
    xdg.configFile = {
      "river/bar" = {
        executable = true;
        text = ''
          #!/usr/bin/env sh

          FIFO="$XDG_RUNTIME_DIR/sandbar"
          [ -e "$FIFO" ] && rm -f "$FIFO"
          mkfifo "$FIFO"

          while cat "$FIFO"; do :; done | sandbar \
          	-font "${fonts.monospace.name}:size=${builtins.toString fonts.sizes.popups}" \
            -no-title \
            -no-layout \
            -hide-normal-mode \
            -vertical-padding 1 \
          	-active-fg-color "#${colors.base07}" \
          	-active-bg-color "#${colors.base02}" \
          	-inactive-fg-color "#${colors.base06}" \
          	-inactive-bg-color "#${colors.base01}" \
          	-urgent-fg-color "#${colors.base00}" \
          	-urgent-bg-color "#${colors.base0E}" \
          	-title-fg-color "#${colors.base05}" \
          	-title-bg-color "#${colors.base00}"
        '';
      };
    };
  };
}
