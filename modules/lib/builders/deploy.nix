{ inputs, ... }:
let
  inherit (import ./default.nix { inherit inputs; })
    mapHostConfigs mkCfg mkPkgs;
  cfgUtil = import ../../my/cfg { inherit (inputs.nixpkgs-unstable) lib; };
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
      nodes = mapHostConfigs dir "configuration" (path: mkNode path attrs);
      profilesOrder = [ "configuration" "droid" "home" ];
    } // (mkDeployCfg orchestratorCfg orchestratorConfig "configuration");

  mkNode = path: attrs:
    let
      cfg = mkCfg path;
      inherit (cfg.sys) stable system genericLinux;
      defPkgs = mkPkgs stable system genericLinux;
    in
    {
      #TODO: domain
      inherit (cfg.sys) hostname;
      #TODO: rewrite this as soon as brain decides to work again
      profiles = {
        configuration = {
          path = defPkgs.deploy-rs.lib.activate.nixos
            inputs.self.nixosConfigurations.${cfg.sys.hostname};
        } // mapDeployCfg cfg { } "configuration";
        home = {
          path = defPkgs.deploy-rs.lib.activate.nixos
            inputs.self.homeConfigurations.${cfg.sys.hostname};
        } // mapDeployCfg cfg { } "home";
        droid = {
          path = defPkgs.deploy-rs.lib.activate.nixos
            inputs.self.nixOnDroidConfigurations.${cfg.sys.hostname};
        } // mapDeployCfg cfg { } "droid";
        system = {
          path = defPkgs.deploy-rs.lib.activate.nixos
            inputs.self.systemConfigs.${cfg.sys.hostname};
        } // mapDeployCfg cfg { } "system";
      };
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
