{ inputs, sys, config, lib, pkgs, ... }:
let
  cfg = config.m.dev.dictate;
  inherit (lib) types mkEnableOption mkIf;
in {
  options.m.dev.dictate.enable = mkEnableOption "enables orchestration tools";
  config = {
    environment.systemPackages =
      if cfg.enable then (with pkgs; [ deploy-rs.deploy-rs ]) else [ ];

    nix = {
      # https://nixos.wiki/wiki/Distributed_build
      buildMachines = map (hostName:
        let
          configs = inputs.self.nixosConfigurations.${
              builtins.unsafeDiscardStringContext hostName
            }.config;
          cfg = builtins.elemAt
            (lib.my.cfg.filterCfgs (c: hostName == c.sys.hostname)) 0;
          ip = let
            ifaces = configs.networking.interfaces;
            inherit (builtins) elemAt attrNames length;
          in if (length (attrNames ifaces) > 0) then
            (elemAt ifaces.${elemAt (attrNames ifaces) 0}.ipv4.addresses
              0).address
          else
            null;
        in {
          hostName = if ip == null then configs.networking.fqdn else ip;
          systems = configs.nix.settings.extra-platforms ++ [ cfg.sys.system ];
          protocol = "ssh-ng";
          # maxJobs = 0;
          # speedFactor = 1;
          supportedFeatures = configs.nix.settings.system-features;
          mandatoryFeatures = [ ];
          sshUser = cfg.usr.username;
        }) (lib.my.cfg.filterHosts (c:
          (builtins.elem "builder" c.sys.flavors) && sys.hostname
          != c.sys.hostname));
      extraOptions = "builders-use-substitutes = true";
      distributedBuilds = true;
    };
  };
}
