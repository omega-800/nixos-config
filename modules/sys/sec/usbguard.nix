{ config, sys, lib, usr, ... }:
let
  cfg = config.m.sec.usb;
  inherit (lib) mkOption types mkIf mkMerge;
in {
  options.m.sec.usb = {
    enable = mkOption {
      description = "enables usbguard";
      type = types.bool;
      default = config.m.sec.enable && sys.hardened (!sys.minimal);
    };
  };
  config = mkIf cfg.enable {
    services.usbguard = {
      enable = true;
      IPCAllowedGroups = [ "wheel" ];
      IPCAllowedUsers = [ "root" ];
    };
    security.polkit = mkIf (usr.wm == "gnome") {
      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if ((action.id == "org.usbguard.Policy1.listRules" ||
               action.id == "org.usbguard.Policy1.appendRule" ||
               action.id == "org.usbguard.Policy1.removeRule" ||
               action.id == "org.usbguard.Devices1.applyDevicePolicy" ||
               action.id == "org.usbguard.Devices1.listDevices" ||
               action.id == "org.usbguard1.getParameter" ||
               action.id == "org.usbguard1.setParameter") &&
               subject.active == true && subject.local == true &&
               subject.isInGroup("wheel")) { return polkit.Result.YES; }
        });
      '';
    };
  };
}
