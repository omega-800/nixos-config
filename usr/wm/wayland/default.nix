{ sys, pkgs, ... }: {
  home = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      QT_ENABLE_HIGHDPI_SCALING = 1;
    };
    packages = with pkgs;
      [
        xdg-desktop-portal
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-utils
        #xdg-mime
        #xdg-open
        #xdg-settings
        grim
        slurp
        wl-clipboard
        wf-recorder
      ] ++ (if sys.genericLinux then
        with pkgs; [ lxqt.lxqt-policykit xwayland xdg-desktop-portal ]
      else
        [ ]);
  };
  services = {
    cliphist = {
      enable = true;
      allowImages = true;
      systemdTarget = "graphical-session.target";
    };
    kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
    };
  };
  systemd.user.services.swhkd = {
    Service.Type = "simple";
    Unit.Description = "simple wayland hotkey daemon";
    Install.WantedBy = [ "default.target" ];
    Service.ExecStart = "${pkgs.writeShellScript "start-swhkd" ''
      #!/usr/bin/env bash
      #${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent
      lxqt-policykit-agent
      pkill -f swhks
      swhks & pkexec swhkd;
    ''}";
  };
}
