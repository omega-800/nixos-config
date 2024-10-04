{ inputs, ... }:
let inherit (import ./default.nix { inherit inputs; }) mapHostConfigs mkCfg;
in rec {
  mapDeployments = dir: attrs: {
    nodes = mapHostConfigs dir "configuration" (path: mkNode path attrs);
    profiles = { };
  };
  mkNode = path: attrs:
    let cfg = mkCfg path;
    in {
      inherit (cfg.sys) hostname;
      profiles.system = {
        user = cfg.usr.username;
        path = inputs.deploy-rs.lib.${cfg.sys.system}.activate.nixos
          inputs.self.nixosConfigurations.${cfg.sys.hostname};
      };
    };
  mapProfiles = attrs: attrs;
}
