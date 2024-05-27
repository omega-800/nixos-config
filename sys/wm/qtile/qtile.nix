{ userSettings, python3Packages, ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver.windowManager.qtile = {
    enable = true;
    configFile = "/home/${userSettings.username}/.config/qtile/config.py";
    backend = "x11";
    extraPackages = with python3Packages; [ 
      yaml 
      qtile-extras
    ];
  };
}
