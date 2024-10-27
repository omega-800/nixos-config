{ lib, config, pkgs, usr, ... }:
with lib;
let
  cfg = config.u.user.alacritty;
  # nixGL = import ../../nixGL/nixGL.nix {inherit config pkgs;};
  inherit (pkgs) nixGL;
  package = nixGL pkgs.alacritty;
in
{
  options.u.user.alacritty.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal && (usr.term == "alacritty");
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ueberzugpp ctpv ];
    programs.alacritty = {
      enable = true;
      inherit package;
      settings = {
        live_config_reload = true;
        selection.save_to_clipboard = true;
        window = {
          opacity = mkForce 0.85;
          padding = {
            y = 8;
            x = 8;
          };
          #          dimensions = {
          #            lines = 3;
          #            columns = 200;
          #          };
        };
        cursor = {
          unfocused_hollow = true;
          style = {
            blinking = "On";
            shape = "Block";
          };
          vi_mode_style = {
            blinking = "Off";
            shape = "Block";
          };
        };
        font = {
          size = mkForce 8;
          bold = {
            family = usr.font;
            style = "Bold";
          };
          bold_italic = {
            family = usr.font;
            style = "Bold Ital";
          };
          italic = {
            family = usr.font;
            style = "Italic";
          };
          normal = {
            family = usr.font;
            style = "Regular";
          };
        };

        keyboard.bindings = [
          {
            action = "IncreaseFontSize";
            key = "i";
            mods = "Control";
          }
          {
            action = "DecreaseFontSize";
            key = "-";
            mods = "Control";
          }
          {
            action = "ResetFontSize";
            key = "=";
            mods = "Control";
          }
        ];
      };
    };
  };
}
