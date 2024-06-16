{ config, ... }: {
  home.file.".xinitrc".text = ''
${config.u.x11.initExtra}
qtile start
  '';   
}
