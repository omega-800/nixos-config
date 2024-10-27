{ config, ... }:
{
  home.file.".config/X11/xinitrc".text = ''
    ${config.u.x11.initExtra}
    qtile start
  '';
}

