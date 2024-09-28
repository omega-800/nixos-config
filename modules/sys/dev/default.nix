{ lib, ... }: {
  imports = [ ./tools.nix ./docker.nix ./mysql.nix ./virt.nix ];
  options.m.dev.enable = lib.mkEnableOption "enables dev tools";
}
