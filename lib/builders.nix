{ inputs, pkgs, lib, ...}: 
with lib;
with builtins;
let
  util = import ./util.nix { inherit inputs pkgs lib; };
  script = import ./sys_script.nix { inherit inputs pkgs lib; };
in rec {
  inherit (util) mkCfg mkSysCfg mkArgs mkPkgs mkHomeMgr mkPkgsStable;
  inherit (script) writeCfgToScript generateInstallerList;

  mkHost = path: attrs:
    let 
      pkgs = mkPkgs cfg.sys.profile cfg.sys.system cfg.sys.genericLinux;
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
      pkgs = mkPkgs cfg.sys.profile cfg.sys.system cfg.sys.genericLinux;
      home-manager = mkHomeMgr cfg;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
# ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
        #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
      extraSpecialArgs  = { 
        inherit inputs; 
        #inherit (cfg.sys) system; 
        inherit (cfg) usr sys;
        pkgs-stable = (mkPkgsStable cfg.sys.system);
        genericLinuxSystemInstaller = writeCfgToScript cfg;# (mkSysCfg path);
        genericLinuxSystemInstallerList = generateInstallerList cfg;# (mkSysCfg path);
        
      };
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

  mapModules = dir: fn:
    filterAttrs
      (n: v: v != null && !(hasPrefix "_" n))
      (mapAttrs'
        (n: v:
          let path = "${toString dir}/${n}"; in
          if v == "directory" && pathExists "${path}/default.nix"
          then nameValuePair n (fn path)
          else if v == "regular" &&
                  n != "default.nix" &&
                  n != "flake.nix" &&
                  hasSuffix ".nix" n
          then nameValuePair (removeSuffix ".nix" n) (fn path)
          else nameValuePair "" null)
        (readDir dir)
      );

}
