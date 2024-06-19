{ usr, pkgs, ... }:
let
  cmd = if usr.wmType == "x11" then "startx" else "Hyprland"; 
in {
  # Enable Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd ${cmd}";
        user = "greeter";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    greetd.tuigreet
  ];
  boot.kernel.sysctl = {
    "kernel.printk" = "3 3 3 3";
  };
}
