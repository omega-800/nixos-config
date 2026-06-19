{
  inputs,
  sys,
  net,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.m.dev.dictate;
  inherit (lib)
    types
    mkOption
    mkIf
    optionals
    ;
  inherit (builtins) elem;
  inherit (lib.omega.cfg) filterCfgs filterHosts;
in
{
  options.m.dev.dictate.enable = mkOption {
    description = "enables orchestration tools";
    type = types.bool;
    default = elem "master" sys.flavors;
  };
  config = {
    environment.systemPackages = optionals cfg.enable (
      with pkgs;
      [
        deploy-rs
        nixos-anywhere
      ]
    );

    nix = mkIf (!cfg.enable) {
      # https://nixos.wiki/wiki/Distributed_build
      # buildMachines = map (
      #   hostName:
      #   let
      #     inherit (builtins) elemAt attrNames length;
      #     ifaces = configs.networking.interfaces;
      #     configs = inputs.self.nixosConfigurations.${builtins.unsafeDiscardStringContext hostName}.config;
      #     cfg = elemAt (filterCfgs (c: hostName == c.net.hostname)) 0;
      #     ip =
      #       if (length (attrNames ifaces) > 0) then
      #         (elemAt ifaces.${elemAt (attrNames ifaces) 0}.ipv4.addresses 0).address
      #       else
      #         null;
      #   in
      #   {
      #     hostName = if ip == null then configs.networking.fqdn else ip;
      #     systems = configs.nix.settings.extra-platforms ++ [ cfg.sys.system ];
      #     protocol = "ssh-ng";
      #     # maxJobs = 0;
      #     # speedFactor = 1;
      #     supportedFeatures = configs.nix.settings.system-features;
      #     mandatoryFeatures = [ ];
      #     sshUser = cfg.usr.username;
      #   }
      # ) (filterHosts (c: (builtins.elem "builder" c.sys.flavors) && net.hostname != c.net.hostname));
      # distributedBuilds = true;
    };
  };
}
