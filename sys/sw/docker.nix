{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.docker;
in {
  options.m.docker = {
    enable = mkEnableOption "enables docker";
  };

  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
    };
    users.users.${usr.username}.extraGroups = [ "docker" ];
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
# lazydocker
    ];
  };
}
