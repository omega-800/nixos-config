{ inputs, pkgs, lib, ... }: 
with lib; 
with builtins; 
rec {
  isStable = cfg: (cfg.sys.profile == "homelab" || cfg.sys.profile == "worklab"); 

  mkPkgsStable = cfg:
    let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (cfg.sys) system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in 
      pkgs-stable;

  mkPkgs = cfg: 
    let 
      stablePkgs = isStable cfg;
      pkgs = (if stablePkgs then pkgs-stable else
                (import nixpkgs-patched {
                  system = cfg.sys.system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                  overlays = [ inputs.rust-overlay.overlays.default ] ++ (if cfg.sys.genericLinux then [ inputs.nixgl.overlay ] else []);
                }));
      nixpkgs-patched =
        (import inputs.nixpkgs { inherit (cfg.sys) system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };
      pkgs-stable = mkPkgsStable cfg;
    in  
      pkgs;

  mkHomeMgr = cfg:
    let
      stablePkgs = isStable cfg;
      home-manager = (if stablePkgs then inputs.home-manager-stable else inputs.home-manager-unstable);
    in
      home-manager;

  mkCfg = path:
    let
      cfg = evalModules {
        modules = [
          ({config, ...}: {config._module.args = {inherit pkgs;};})
          ../profiles/default/options.nix
          (import "${path}/config.nix")
        ];
      };
    in 
      cfg.config.c;

  mkArgs = cfg:
    let
      args = { 
        inherit lib inputs system; 
        inherit (cfg) usr sys;
        pkgs-stable = (mkPkgsStable cfg);
      };
    in 
      args;

  mkHost = path: attrs:
    let 
      cfg = mkCfg path;
      inherit (cfg.sys) system;
    in
      nixosSystem {
        inherit system;
        specialArgs = mkArgs cfg;

        modules = [
          ../profiles/default/configuration.nix
          ../profiles/${cfg.sys.profile}/configuration.nix
          (import "${path}/configuration.nix")
          (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ];
      };

  mapHosts = dir: attrs @ { system ? system, ... }:
    mapHostConfigs dir "configuration" (path: mkHost path attrs);

  mkHome = path: attrs:
    let
      cfg = mkCfg path;
      pkgs = mkPkgs path;
      home-manager = mkHomeMgr cfg;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = mkArgs cfg;
        modules = [
          ../profiles/default/home.nix
          ../profiles/${cfg.sys.profile}/home.nix
          (import "${path}/home.nix")
          (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ];
      };

  mapHomes = dir: attrs @ { system ? system, ... }:
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
