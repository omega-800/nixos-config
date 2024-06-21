{ inputs, pkgs, lib, ...}: 
with lib;
with builtins;
let
  util = import ./util.nix { inherit inputs pkgs lib; };
  script = import ./sys_script.nix { inherit inputs pkgs lib; };
in rec {
  inherit (util) mkCfg mkArgs mkPkgs mkHomeMgr;
  inherit (script) writeCfgToScript;

  mkHost = path: attrs:
    let 
      pkgs = mkPkgs cfg;
      cfg = mkCfg path;
    in
      nixosSystem {
        inherit (cfg.sys) system;
        /*
        specialArgs = mkMerge [
          (mkArgs cfg)
          {lib = mkLib cfg;}
        ];
*/
        specialArgs = mkArgs cfg;
        modules = [
        ({
# clearly i do NOT understand how nix works
            nixpkgs.overlays = [
                inputs.nur.overlay
            ];
          })
          ../profiles/default/configuration.nix
          ../profiles/${cfg.sys.profile}/configuration.nix
          (import "${path}/configuration.nix")
          (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ];
      };

  mapHosts = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkHost path attrs);

  mkHome = path: attrs:
    let
      cfg = mkCfg path;
      pkgs = mkPkgs cfg;
      home-manager = mkHomeMgr cfg;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
        modules = [
          ../profiles/default/home.nix
          ../profiles/${cfg.sys.profile}/home.nix
          (import "${path}/home.nix")
          (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ];
      };

  mapHomes = dir: attrs:
    mapHostConfigs dir "home" (path: mkHome path attrs);

  mapHostConfigs = dir: type: fn:
    filterAttrs 
      (n: v: v != null && !(hasPrefix "_" n))
      (mapAttrs'
        (n: v: 
          let path = "${toString dir}/${n}"; in
          if v == "directory" && pathExists "${path}/${type}.nix"
          then nameValuePair n (fn path)
          else nameValuePair "" null)
        (readDir dir)
      );
}
