{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    layout = "ch";
    xkbVariant = "de";
    excludePackages = [ pkgs.xterm ];
    displayManager = {
      startx.enable = true;
    };
    libinput = {
      touchpad.disableWhileTyping = true;
    };
  };
}
