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
  };
}
