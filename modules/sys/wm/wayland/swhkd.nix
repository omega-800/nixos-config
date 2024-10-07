{
  services.swhkd = {
    enable = false;
    swhkdrc = ''
      Super_L + o + r
          rofi -m -4 -show drun
    '';
  };
}
