{ pkgs, lib, usr, ... }:

{
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
}
