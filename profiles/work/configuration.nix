{ usr, ... }: {
  imports =
    [
      ../../sys/wm/${usr.wm}
      ../../sys/wm/${usr.wmType}
      ../../sys/wm/dm
    ];
  m = {
    audio = {
      enable = true;
      pipewire = true;
      bluetooth = true;
    };
    automount.enable = true;
    kernel.zen = true;
    openGL.enable = true;
    printing.enable = true;
    docker.enable = true;
    virt.enable = true;
    flatpak.enable = true;
    mysql.enable = true;
    devtools.enable = true;
    fancyfonts.enable = true;
    vpn = {
      forti.enable = true;
      wg.enable = true;
# wrong one
      openvpn.enable = false;
      mullvad.enable = false;
    };
  };
}
