{ inputs }:
let
  inherit (import ../utils { inherit inputs; })
    getInput
    mkCfg
    mkArgs
    mkModules
    getPkgsInput
    mkOverlays
    mapHostConfigs
    CONFIGS
    PATHS
    ;
in
{
  #TODO: implement correctly
  mapIsos =
    hostname:
    let
      cfg = mkCfg hostname;
    in
    (getPkgsInput cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      # FIXME: overlays
      specialArgs = mkArgs cfg;
      modules = [
        (PATHS.NODES + /${hostname}/${CONFIGS.nixosConfiguration}.nix)
        (PATHS.MODULES + /${CONFIGS.nixosConfiguration}/fs/disko/default.nix)
        (
          {
            pkgs,
            config,
            modulesPath,
            ...
          }:
          {
            imports = [
              (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
              (getInput "disko" cfg.sys.stable).nixosModules.disko
            ];
            config = {
              nixpkgs.overlays = mkOverlays cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
              disko.enableConfig = false;
              services.btrfs.autoScrub.enable = false;
              sops.secrets."hosts/default/disk" = { };
              environment.systemPackages =
                let
                  # disko
                  disko = pkgs.writeShellScriptBin "disko" "${config.system.build.diskoScript}";
                  disko-mount = pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
                  disko-format = pkgs.writeShellScriptBin "disko-format" "${config.system.build.formatScript}";
                in
                [
                  disko
                  disko-mount
                  disko-format
                  pkgs.neovim
                ];
            };
          }
        )
      ]; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

}
