{ lib, config, pkgs, usr, ... }:
with lib;
let
  nixGL = import ../../nixGL/nixGL.nix { inherit pkgs config; };
  cfg = config.u.user.kitty;
in
{
  options.u.user.kitty.enable = mkOption {
    type = types.bool;
    default = config.u.user.enable && !usr.minimal;
  };

  config = mkIf (cfg.enable && usr.term == "kitty") {
    programs.kitty = {
      enable = true;
      package = (nixGL pkgs.kitty);
      font.size = mkForce 12;
      shellIntegration = {
        mode = "no-sudo no-rc no-cursor";
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
      settings = {
        background_opacity = mkForce "0.85";
        scrollback_lines = 10000;
        enable_audio_bell = false;
        update_check_interval = 0;
        cursor_shape = "block";
        cursor_shape_unfocused = "hollow";
        cursor_blink_interval = 1;
        cursor_stop_blinking_after = 60;
      };
    };
  };
}
