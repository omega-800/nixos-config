{ ... }: {
  imports = [ ../x11/x11.nix ];
  services.xserver.windowManager.qtile.enable = true;
}
