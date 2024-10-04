{ inputs, ... }:
let
  inherit (import ./default.nix { inherit inputs; })
    mapHostConfigs mkCfg mkPkgs;
in
rec {
  mapDeployments = dir: attrs: {
    nodes = mapHostConfigs dir "configuration" (path: mkNode path attrs);
  };
  mkDeployCfg = cfg: config: {
    #TODO: getOrchestrator -> cfg
    # check if only orchestrator in all hosts
    sshUser = cfg.usr.username;
    user = cfg.usr.username;
    sudo = "${if config.security.sudo.enable then "sudo" else "doas"} -u";
    ipteractiveSudo = false;
    sshOpts = [ "-p" "22" ];
    fastConnection = false;
    autoRollback = true;
    magicRollback = true;
    tempPath = "/root/.deploy-rs";
    remoteBuild = false;
    activationTimeout = 600;
    confirmTimeout = 60;
  }
    mkNode = path: attrs:
  let
  cfg = mkCfg path;
  inherit (cfg.sys) stable system genericLinux;
  defPkgs = mkPkgs stable system genericLinux;
  in
  {
  inherit (cfg.sys) hostname;
  profiles.system = {
    user = cfg.usr.username;
    path = defPkgs.deploy-rs.lib.activate.nixos
      inputs.self.nixosConfigurations.${cfg.sys.hostname};
  };
};
mapProfiles = attrs: attrs;
}
