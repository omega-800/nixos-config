{ usr, ... }: {
  imports =
    [
      ../../sys/wm/${usr.wm}
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
