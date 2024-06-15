{ config, ... }: {
  imports =
    [
      ../../sys/wm/${config.c.usr.wm}
    ];
  m.audio = {
    enable = true;
    pipewire = true;
    bluetooth = true;
  };
  m.automount.enable = true;
  m.kernel.zen = true;
  m.openGL.enable = true;
  m.printing.enable = true;
}
