{ userSettings, ... }: {
  imports =
    [
      ../../sys/wm/${userSettings.wm}
      ../../sys
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
  m.power = {
    enable = true;
    performance = true;
  };
}
