{ lib, config, ... }:
let
  cfg = config.m.hw.io;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.m.hw.io = {
    enable = mkEnableOption "enables input";
    touchpad.enable = mkEnableOption "enables touchpad";
    # TODO: mkDisableOption 
    homeMods.disable = mkEnableOption "disables home modifier keys";
    swapCaps.disable = mkEnableOption
      "doesn't swap capslock with backspace; defaults are important, everybody that doesn't think like me should be reinstitutionalized";
  };
  config = {
    services = mkIf cfg.enable {
      /* keyd = mkIf (!cfg.swapCaps.disable) {
           enable = true;
           keyboards.default = {
             ids = [ "*" ];
             settings.main = {
               capslock = "backspace";
               backspace = "capslock";
             };
           };
         };
      */
      kanata = mkIf (!cfg.homeMods.disable || !cfg.swapCaps.disable) {
        enable = true;
        keyboards.main = {
          devices = [
            "/dev/input/by-path/pci-0000:00:1f.3-platform-skl_hda_dsp_generic-event"
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-path/platform-INT33D5:00-event"
          ];

          # https://github.com/dreamsofcode-io/home-row-mods/blob/main/kanata/linux/kanata.kbd
          extraDefCfg = "process-unmapped-keys yes";
          config = # lisp
            ''
              (defsrc
                ${if cfg.swapCaps.disable then "" else "caps bspc"}
                ${if cfg.homeMods.disable then "" else "a s d f j k l ;"}
              )
              (defvar
                tap-time 150
                hold-time 200
              )
              (defalias
                ${
                  if cfg.homeMods.disable then
                    ""
                  else ''
                    a (tap-hold $tap-time $hold-time a lalt)
                    s (tap-hold $tap-time $hold-time s lmet)
                    d (tap-hold $tap-time $hold-time d lsft)
                    f (tap-hold $tap-time $hold-time f lctl)
                    j (tap-hold $tap-time $hold-time j rctl)
                    k (tap-hold $tap-time $hold-time k rsft)
                    l (tap-hold $tap-time $hold-time l rmet)
                    ; (tap-hold $tap-time $hold-time ; ralt)
                  ''
                }
              )
              (deflayer base
                ${if cfg.swapCaps.disable then "" else "bspc caps"}
                ${
                  if cfg.homeMods.disable then "" else "@a @s @d @f @j @k @l @;"
                }
              )
            '';
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
