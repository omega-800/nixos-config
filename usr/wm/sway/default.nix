{ pkgs, ... }:{
  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "alacritty"; 
      startup = [
        {command = "alacritty";}
      ];
    };
  };
  services = {
    swayidle = {
      enable = true;
      events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -fF"; }
      { event = "lock"; command = "lock"; }
      ];
    };
    swaylock = {
      enable = true;
      settings = {
        show-failed-attempts = true;
      };
    };
  };
}
