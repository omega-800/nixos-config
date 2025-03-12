{
  lib,
  globals,
  sys,
  config,
  usr,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.wm.x11;
in
{
  config = mkIf cfg.enable {
    services.autorandr = {
      enable = true;
      ignoreLid = false;
    };
    programs.autorandr = {
      enable = true;
      profiles = {
        work = {
          fingerprint = {
            DP2-2 = "00ffffffffffff0022f06e3200000000011b0104a5342078220285a556549d250e5054210800b30095008100d1c0a9c081c0a9408180283c80a070b023403020360006442100001a000000fd00323c1e5011010a202020202020000000fc00485020453234320a2020202020000000ff00434e34373031314736500a20200099";
            DP2-3 = "00ffffffffffff0022f049290101010109150104a5331d78261e55a059569f270d5054a1080081c081809500b300d1c0010101010101023a801871382d40582c4500fd1e1100001e000000fd00324c185e11000a202020202020000000fc004850204c41323330360a202020000000ff00334351313039304350310a202000e8";
            eDP1 = "00ffffffffffff0026cf413d04000000001d0104a52213780ade50a3544c99260f505400000001010101010101010101010101010101383680a07038204018303c0058c210000019000000fe00583135364e564638205231200a00000003000354d804647d1512169600000000000003001e5fff64a0a917124ea901010000a8";
          };
          config = {
            DP1.enable = false;
            DP2.enable = false;
            DP2-1.enable = false;
            DP3.enable = false;
            DP4.enable = false;
            HDMI1.enable = false;
            VIRTUAL1.enable = false;
            eDP1 = {
              enable = true;
              crtc = 0;
              mode = "1920x1080";
              position = "0x0";
              primary = true;
              rate = "60.01";
              # x-prop-broadcast_rgb = "Automatic";
              # x-prop-colorspace = "Default";
              # x-prop-max_bpc = 12;
              # x-prop-non_desktop = 0;
              # x-prop-scaling_mode = "Full aspect";
            };
            DP2-2 = {
              enable = true;
              crtc = 1;
              mode = "1920x1200";
              position = "1920x0";
              rate = "59.95";
              # x-prop-audio = "auto";
              # x-prop-broadcast_rgb = "Automatic";
              # x-prop-max_bpc = 12;
              # x-prop-non_desktop = 0;
            };
            DP2-3 = {
              enable = true;
              crtc = 2;
              mode = "1920x1080";
              position = "3840x0";
              rate = "60.0";
              # x-prop-audio = "auto";
              # x-prop-broadcast_rgb = "Automatic";
              # x-prop-max_bpc = 12;
              # x-prop-non_desktop = 0;
            };
          };
        };
      };
    };
  };
}
