{ lib, config, pkgs, usr, ... }:
with lib;
let cfg = config.m.dev.docker;
in {
  options.m.dev.docker = {
    enable = mkOption {
      description = "enables docker";
      type = types.bool;
      default = config.m.dev.enable;
    };
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
