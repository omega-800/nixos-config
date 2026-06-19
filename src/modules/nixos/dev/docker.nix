{
  sys,
  lib,
  config,
  pkgs,
  usr,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkDefault
    ;
  inherit (lib.omega.cfg) mkSpecialisation;
  cfg = config.m.dev.docker;
in
{
  options.m.dev.docker.enable = mkEnableOption "docker";

  config = mkIf cfg.enable (mkMerge [
    (mkSpecialisation "serv" {
      virtualisation.docker.enableOnBoot = true;
    })
    {
      virtualisation.docker = {
        enable = true;
        enableOnBoot = mkDefault false;
        autoPrune.enable = true;
      };
      users.users.${usr.username}.extraGroups = [ "docker" ];
      environment = {
        persistence = mkIf config.m.fs.disko.root.impermanence.enable {
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
    }
  ]);
}
