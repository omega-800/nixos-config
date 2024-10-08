{ lib, config, ... }:
let
  cfg = config.m.hw.io;
  inherit (lib) mkIf mkEnableOption;
in {
  options.m.hw.io = {
    enable = mkEnableOption "enables input";
    touchpad.enable = mkEnableOption "enables touchpad";
    swapCaps.disable = mkEnableOption
      "doesn't swap capslock with backspace; defaults are important, everybody that doesn't think like me should be reinstitutionalized";
  };
  config = {
    services = mkIf cfg.enable {
      keyd = mkIf (!cfg.swapCaps.disable) {
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
        # only enable if config.services.xserver.enable
        # enable = true;
        touchpad = mkIf cfg.touchpad.enable {
          tapping = true;
          middleEmulation = true;
          disableWhileTyping = true;
        };
      };
    };
  };
}
