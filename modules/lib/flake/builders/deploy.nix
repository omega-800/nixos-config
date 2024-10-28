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
    dir: attrs:
    let
      # mhm yes very good quality code
      orchestrator = cfgUtil.getOrchestrator;
      orchestratorCfg = mkCfg (dir + "/${orchestrator}");
      orchestratorConfig = (mkHost (dir + "/${orchestrator}") { }).modules.config;
    in
    {
      nodes = lib.mapAttrs' (n: v: lib.nameValuePair n (mkNode (dir + "/${n}") attrs)) (
        lib.filterAttrs (n: v: v == "directory" && !(lib.hasPrefix "_" n)) (builtins.readDir dir)
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
    dir: attrs:
    let
      cfg = mkCfg dir;
      inherit (cfg.sys) stable system genericLinux;
      defPkgs = mkPkgs stable system genericLinux;
    in
    {
      #TODO: domain
      inherit (cfg.sys) hostname;
      profiles = lib.mapAttrs' (
        n: t:
        lib.nameValuePair t (
          {
            path =
              defPkgs.deploy-rs.lib.activate.nixos
                inputs.self.${n}.${builtins.unsafeDiscardStringContext cfg.sys.hostname};
          }
          // (mkDeployCfg cfg { } t)
        )
      ) (lib.filterAttrs (n: t: builtins.pathExists (dir + "/${t}.nix")) CONFIGS);
    };

  mapProfiles = attrs: attrs;

  mkDeployCfg = cfg: config: type: {
    sshUser = cfg.usr.username;
    user = if (type == CONFIGS.homeConfigurations) then cfg.usr.username else "root";
    sudo = "${
      # if config.m.sec.priv.sudo.enable then "sudo" else
      "doas"
    } -u";
    ipteractiveSudo = false;
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
