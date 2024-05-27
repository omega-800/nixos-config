{ userSettings, pkgs, ... }: {
  imports = [ ../x11/x11.nix ];

  services.xserver.windowManager.qtile = {
    enable = true;
    configFile = "/home/${userSettings.username}/.config/qtile/config.py";
    backend = "x11";
    extraPackages = python3Packages: with python3Packages; [
      pyyaml
      qtile-extras
    ];
  };
}
