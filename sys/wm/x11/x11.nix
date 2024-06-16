{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb = {
      layout = "ch";
      variant = "de";
    };
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      startx.enable = true;
    };
  };
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      middleEmulaion = true;
      disableWhileTyping = true;
    };
  };
}
