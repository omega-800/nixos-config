{
  lib,
  config,
  pkgs,
  usr,
  ...
}:
with lib;
let
  cfg = config.m.dev.docker;
in
{
  options.m.dev.docker.enable = mkEnableOption "enables docker";

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
    users.users.${usr.username}.extraGroups = [ "docker" ];
    environment = {
      persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
        "/nix/persist".directories = [
          # putting lxd here to not forget that it exists
          "/var/lib/lxd"
          "/var/lib/docker"
        ];
      };
      systemPackages = with pkgs; [
        docker
        docker-compose
        # lazydocker
      ];
    };
  };
}
