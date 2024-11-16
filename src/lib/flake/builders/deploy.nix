{ inputs, ... }:
let
  inherit (import ../utils { inherit inputs; })
    getInput
    mapHostConfigs
    mkCfg
    mkPkgs
    mkHost
    CONFIGS
    hasHostConfig
    PATHS
    ;
  cfgUtil = import ../omega/cfg.nix { inherit (inputs.nixpkgs-unstable) lib; };
  inherit (inputs.nixpkgs-unstable) lib;
in
rec {
  # mapDeployments = _: attrs: 
  #   {
  #     nodes = lib.mapAttrs (_: config: {
  #       profiles.${CONFIGS.nixosConfigurations} = {
  #         user = "root";
  #         path = inputs.deploy-rs.lib.${config}
  #       }
  #
  #       }) inputs.self.nixosConfigurations;
  #     profilesOrder = [
  #       CONFIGS.nixosConfigurations
  #       CONFIGS.systemConfigs
  #       CONFIGS.nixOnDroidConfigurations
  #       CONFIGS.homeConfigurations
  #     ];
  #   } // (mkDeployCfg orchestratorCfg orchestratorConfig
  #     CONFIGS.nixosConfigurations);

  mapDeployments =
    let
      # mhm yes very good quality code
      orchestrator = cfgUtil.getOrchestrator;
      orchestratorCfg = mkCfg orchestrator;
      orchestratorConfig = (mkHost orchestrator).modules.config;
    in
    {
      nodes = lib.mapAttrs' (n: v: lib.nameValuePair n (mkNode n)) (
        lib.filterAttrs (n: v: v == "directory" && !(lib.hasPrefix "_" n)) (builtins.readDir PATHS.NODES)
      );
      profilesOrder = [
        CONFIGS.nixosConfigurations
        CONFIGS.systemConfigs
        CONFIGS.nixOnDroidConfigurations
        CONFIGS.homeConfigurations
      ];
    }
    // (mkDeployCfg orchestratorCfg orchestratorConfig CONFIGS.nixosConfigurations);

  mkNode =
    hostname:
    let
      cfg = mkCfg hostname;
      inherit (cfg.sys) stable system genericLinux;
      defPkgs =
        ((mkPkgs stable system genericLinux).extend (getInput "deploy-rs" stable).overlay).extend
          (
            self: super: {
              deploy-rs = {
                inherit (mkPkgs stable system genericLinux) deploy-rs;
                inherit (super.deploy-rs) lib;
              };
            }
          );
    in
    {
      #TODO: domain
      inherit hostname;
      profiles =
        lib.mapAttrs'
          (
            n: t:
            lib.nameValuePair t (
              {
                path = defPkgs.deploy-rs.lib.activate.nixos (
                  inputs.self.${n}.${hostname}
                  # // (lib.optionalAttrs (n == CONFIGS.homeConfigurations) { inherit system; })
                );
              }
              // (mkDeployCfg cfg inputs.self.${n}.${hostname}.config t)
            )
          )
          (
            lib.filterAttrs
              # (n: t: builtins.pathExists (PATHS.NODES + /${hostname}/${t}.nix)) 
              (n: t: (lib.hasAttr n inputs.self) && (lib.hasAttr hostname inputs.self.${n}))
              CONFIGS
          );
    };

  mkDeployCfg = cfg: config: type: {
    # FIXME: this is so scuffed. i guess i'll just use a plain nixos-rebuild
    # sshUser = cfg.usr.username;
    sshUser = "root";
    # user = if (type == CONFIGS.homeConfigurations) then cfg.usr.username else "root";
    user = "root";
    sudo = "${
      # if config.m.sec.priv.sudo.enable then "sudo" else
      "doas"
    } -u";
    interactiveSudo = false;
    sshOpts = [
      "-p"
      "22" # (toString (builtins.elemAt config.services.openssh.ports 0))
    ];
    fastConnection = false;
    autoRollback = true;
    magicRollback = true;
    tempPath = "${
      if (type == CONFIGS.homeConfigurations) then cfg.usr.homeDir else "/root"
    }/.deploy-rs";
    remoteBuild = false; # builtins.elem "beast" cfg.sys.profiles;
    activationTimeout = 600;
    confirmTimeout = 60;
  };
}
