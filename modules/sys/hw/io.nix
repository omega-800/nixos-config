{ lib, config, ... }:
with lib;
let cfg = config.m.hw.io;
in {
  options.m.hw.io = {
    enable = mkEnableOption "enables input";
    touchpad.enable = mkEnableOption "enables touchpad";
    swapCaps.enable = mkOption {
      description = "swaps capslock with backspace";
      type = types.bool;
      default = true;
    };
  };
  config = {
    services = mkIf cfg.enable {
      keyd = mkIf cfg.swapCaps.enable {
        enable = true;
        keyboards.default = {
          ids = [ "*" ];
          settings.main = {
            capslock = "backspace";
            backspace = "capslock";
          };
        };
      };
      libinput = {
        enable = true;
        touchpad = mkIf cfg.touchpad.enable {
          tapping = true;
          middleEmulation = true;
          disableWhileTyping = true;
        };
      };
    };
  };
}
