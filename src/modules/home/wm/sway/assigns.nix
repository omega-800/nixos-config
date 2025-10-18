let
  terminals = [
    { class = "kitty"; }
    { class = "alacritty"; }
    { class = "foot"; }
  ];
  browsers = [
    { class = "firefox"; }
    { class = "vieb"; }
    { class = "qutebrowser"; }
    { class = "Chromium-browser"; }
    { class = "Brave-browser"; }
  ];
  work = {
    "1" = [
      { class = "Brave-browser"; }
      { class = "Chromium-browser"; }
      { title = "aerc"; }
    ];
    "2" = terminals;
    "3" = [
      { class = "Code"; }
      { class = "Eclipse"; }
    ];
    "4" = [
      { class = "firefox"; }
      { class = "vieb"; }
      { class = "qutebrowser"; }
    ];
    "5" = [
      { class = "Zathura"; }
      { class = "libreoffice"; }
      { class = "feh"; }
      { class = "mpv"; }
    ];
    "6" = [
      { class = "draw.io"; }
      { class = "gimp.*"; }
      { class = "Inkscape"; }
    ];
    "7" = [
      { class = "postman"; }
      { title = "travel .*"; }
      { class = "RemoteDesktopManager"; }
    ];
    "8" = [
      { class = "org.remmina.Remmina"; }
      { class = "virt-manager"; }
      { class = "bottles"; }
    ];
    "9" = [
      { class = "Spotify"; }
      { title = "ncmpcpp"; }
      { class = "pavucontrol"; }
    ];
    "0" = [ ];
  };
in {
  school = work;
  pers = {
    "1" = terminals;
    "2" = [ ];
    "3" = browsers;
    "4" = [ ];
    "5" = [ ];
    "6" = [
      { class = "Zathura"; }
      { class = "libreoffice"; }
      { class = "feh"; }
      { class = "mpv"; }
    ];
    "7" = [
      { class = "draw.io"; }
      { class = "gimp.*"; }
      { class = "Inkscape"; }
    ];
    "8" = [
      { class = "postman"; }
      { class = "virt-manager"; }
      { class = "bottles"; }
    ];
    "9" = [
      { class = "Spotify"; }
      { title = "ncmpcpp"; }
      { class = "pavucontrol"; }
    ];
    "0" = [ ];
  };
}
