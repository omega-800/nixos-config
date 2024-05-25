{ ... }:
with lib;
let cfg = config.u.xmonad;
in {
  options.u.xmonad = {
    enable = mkEnableOption "enables xmonad";
  };
 
  config = mkIf cfg.enable {
    # import X11 config
    imports = [ ../x11/x11.nix ];

    # Setup XMonad
    services.xserver = {
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };
      displayManager = {
        defaultSession = "none+xmonad";
      };
    };
  };
}
