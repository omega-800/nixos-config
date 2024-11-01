{ lib, config, ... }:
let
  cfg = config.m.hw.io;
  inherit (lib) mkIf mkEnableOption optionalString;
  inherit (lib.omega.def) mkDisableOption;
  hm = cfg.homeMods.enable;
  vl = cfg.vimLayer.enable;
  sc = cfg.swapCaps.enable;
in
{
  options.m.hw.io = {
    enable = mkEnableOption "enables input";
    touchpad.enable = mkEnableOption "enables touchpad";
    homeMods.enable = mkDisableOption "enables home modifier keys";
    vimLayer.enable = mkDisableOption "enables vim layer";
    swapCaps.enable = mkDisableOption
      "swaps capslock with backspace; defaults are important, everybody that doesn't think like me should be reinstitutionalized";
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
      kanata = mkIf (hm || vl || sc) {
        enable = true;
        keyboards.dactyl = {
          devices = [
            "/dev/input/by-id/usb-tshort_Dactyl_Manuform_4x6_5_thumb_keys-event-if01"
            "/dev/input/by-id/usb-tshort_Dactyl_Manuform_4x6_5_thumb_keys-event-kbd"
          ];

          extraDefCfg = "process-unmapped-keys yes";
          # TODO: configure configs per-keyboard

          config = # lisp
            ''
              (defsrc
                caps bspc 
              )
              (deflayermap (base)
                    caps bspc 
                    bspc caps
              )
            '';
        };
        keyboards.main = {
          devices = [
            "/dev/input/by-path/pci-0000:00:1f.3-platform-skl_hda_dsp_generic-event"
            "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
            "/dev/input/by-path/platform-INT33D5:00-event"
          ];

          extraDefCfg = "process-unmapped-keys yes";
          config = # lisp
            ''
              (defsrc
                caps bspc u i a s d f g h j k l ;
              )
              (defvar
                tap-time 150
                hold-time 200
              )
              (deflayermap (base)
                ${
                  optionalString sc ''
                    caps bspc 
                    bspc caps
                  ''
                }
                ${
                  optionalString hm ''
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
                ${
                  optionalString vl ''
                    lsft esc
                    rsft (layer-switch vim)
                    lctl (tap-hold $tap-time $hold-time spc (layer-while-held vim))
                  ''
                }
              )
              ${optionalString vl ''
                (deflayermap (vim)
                  ${
                    optionalString sc ''
                      caps bspc 
                      bspc caps
                    ''
                  }
                  lsft esc
                  rsft (layer-switch base)
                  spc (tap-hold $tap-time $hold-time spc (layer-while-held base))
                  h left 
                  j down 
                  k up 
                  l right
                  g tab 
                  u pgup 
                  d pgdn 
                  a end 
                  i home
                  f esc
                  s lsft
                )
              ''}
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
