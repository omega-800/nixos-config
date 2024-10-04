{ inputs, ... }:
let
  inherit (import ./default.nix { inherit inputs; })
    mapHostConfigs mkCfg mkPkgs mkHost CONFIGS hasHostConfig;
  cfgUtil = import ../../my/cfg { inherit (inputs.nixpkgs-unstable) lib; };
  inherit (inputs.nixpkgs-unstable) lib;
in
rec {
  mapDeployments = dir: attrs:
    let
      # mhm yes very good quality code
      orchestrator = cfgUtil.getOrchestrator;
      orchestratorCfg = mkCfg ./.${dir}/${orchestrator};
      orchestratorConfig =
        (mkHost ./.${dir}/${orchestrator} { }).modules.config;
    in
    {
      nodes = lib.mapAttrs'
        (n: v: lib.nameValuePair n (mkNode "${toString dir}/${n}" attrs))
        (lib.filterAttrs (n: v: v == "directory" && !(lib.hasPrefix "_" n))
          (builtins.readDir dir));
      profilesOrder = [
        CONFIGS.nixosConfigurations
        CONFIGS.systemConfigs
        CONFIGS.nixOnDroidConfigurations
        CONFIGS.homeConfigurations
      ];
    } // (mkDeployCfg orchestratorCfg orchestratorConfig
      CONFIGS.nixosConfigurations);

  mkNode = path: attrs:
    let
      cfg = mkCfg path;
      inherit (cfg.sys) stable system genericLinux;
      defPkgs = mkPkgs stable system genericLinux;
    in
    {
      #TODO: domain
      inherit (cfg.sys) hostname;
      profiles = lib.mapAttrs'
        (n: t:
          lib.nameValuePair t ({
            path = defPkgs.deploy-rs.lib.activate.nixos
              inputs.self.${n}.${cfg.sys.hostname};
          } // (mkDeployCfg cfg { } t)))
        (lib.filterAttrs (n: t: builtins.pathExists "${path}/${t}.nix")
          CONFIGS);
    };

  mapProfiles = attrs: attrs;

  mkDeployCfg = cfg: config: type: {
    sshUser = cfg.usr.username;
    user = if type == "home" then cfg.usr.username else "root";
    sudo = "${ # if config.m.sec.priv.sudo.enable then "sudo" else
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
    tempPath =
      "${if type == "home" then cfg.usr.homeDir else "/root"}/.deploy-rs";
    remoteBuild = false; # builtins.elem "beast" cfg.sys.profiles;
    activationTimeout = 600;
    confirmTimeout = 60;
  };
}
