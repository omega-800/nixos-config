{ inputs, sys, config, lib, pkgs, ... }:
let
  cfg = config.m.dev.dictate;
  inherit (lib) types mkOption mkIf;
in
{
  options.m.dev.dictate.enable = mkOption {
    description = "enables orchestration tools";
    type = types.bool;
    default = config.m.dev.enable && (builtins.elem "master" sys.flavors);
  };
  config = {
    environment.systemPackages =
      if cfg.enable then (with pkgs; [ deploy-rs.deploy-rs ]) else [ ];

    nix = {
      buildMachines = map
        (hostName:
          let
            configs = inputs.self.nixosConfigurations.${
            builtins.unsafeDiscardStringContext hostName
            }.config;
            cfg = lib.my.cfg.filterCfgs (c: hostName == c.sys.hostname);
            ip =
              let ifaces = configs.networking.interfaces;
              in with builtins;
              (elemAt ifaces.${elemAt (attrNames ifaces) 0}.ipv4.addresses
                0).address;
          in
          {
            hostName = if ip == null then configs.networking.fqdn else ip;
            systems = configs.nix.settings.extra-platforms ++ [ cfg.sys.system ];
            protocol = "ssh-ng";
            # maxJobs = 0;
            # speedFactor = 1;
            supportedFeatures = configs.nix.settings.system-features;
            mandatoryFeatures = [ ];
            sshUser = cfg.usr.username;
          })
        (lib.my.cfg.filterHosts (c:
          (builtins.elem "builder" c.sys.flavors) && sys.hostname
          != c.sys.hostname));
      extraOptions = "builders-user-substitutes = true";
      distributedBuilds = true;
    };
  };
}
