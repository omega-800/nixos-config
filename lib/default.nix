{ inputs, pkgs, lib, ... }: 
with lib; 
with builtins; 
rec {
  isStable = profile: (profile == "homelab" || profile == "worklab"); 

  mkLib = cfg:
    let 
      stablePkgs = isStable cfg.sys.profile;
      lib = (if stablePkgs then inputs.nixpkgs-stable.lib else inputs.nixpkgs.lib).extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in
      lib;

  mkPkgsStable = system:
    let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in 
      pkgs-stable;

  mkPkgsUnstable = cfg:
    let
      pkgs-unstable = (import nixpkgs-patched {
        system = cfg.sys.system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = [ 
          inputs.rust-overlay.overlays.default 
          inputs.nur.overlay 
        ] ++ (if cfg.sys.genericLinux then [ inputs.nixgl.overlay ] else []);
      });
      nixpkgs-patched =
        (import inputs.nixpkgs { inherit (cfg.sys) system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };
    in 
      pkgs-unstable;

  mkPkgs = cfg: 
    let 
      stablePkgs = isStable cfg.sys.profile;
      pkgs-stable = mkPkgsStable cfg.sys.system;
      pkgs-unstable = mkPkgsUnstable cfg;
      pkgs = if stablePkgs then pkgs-stable else pkgs-unstable;
    in  
      pkgs;

  mkHomeMgr = cfg:
    let
      stablePkgs = isStable cfg.sys.profile;
      home-manager = (if stablePkgs then inputs.home-manager-stable else inputs.home-manager-unstable);
    in
      home-manager;

  tooStupidToMatchRegex = expr: path:
    (lists.last (flatten (sublist 1 1 (split expr (readFile path)))));
    
  hackyHackHackToEvaluateProfileBeforeEvaluatingTheWholeConfigBecauseItDependsOnThePackageVersionDependingOnTheProfile = path:
    let 
      cfgPath = path + "/config.nix";
      stablePkgs = isStable (tooStupidToMatchRegex "profile = \"([[:lower:]]+)\";\n" cfgPath);
      system = (tooStupidToMatchRegex "system = \"([[:print:]]+)\";\n" cfgPath);
      pkgs = (if stablePkgs then pkgs-stable else
                (import nixpkgs-patched {
                  inherit system;
                  config = {
                    allowUnfree = true;
                    allowUnfreePredicate = (_: true);
                  };
                  overlays = [ 
                    inputs.rust-overlay.overlays.default 
                    inputs.nur.overlay 
                  ] ++ (if (tooStupidToMatchRegex "genericLinux = ([[:lower:]]+);\n" cfgPath) == "true"  then [ inputs.nixgl.overlay ] else []);
                }));
      nixpkgs-patched =
        (import inputs.nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };
      pkgs-stable = mkPkgsStable system;
    in  
      pkgs;

  # fuck it i'm just gonna use unstable 
  mkCfg = path:
    let
      hackyPkgs = hackyHackHackToEvaluateProfileBeforeEvaluatingTheWholeConfigBecauseItDependsOnThePackageVersionDependingOnTheProfile path;
      cfg = evalModules {
        modules = [
          ({config, ...}: {config._module.args = {pkgs = hackyPkgs;};})
          ../profiles/default/options.nix
          (import "${path}/config.nix")
        ];
      };
    in 
      cfg.config.c;

  mkArgs = cfg:
    let
      args = { 
        inherit inputs; 
        #inherit (cfg.sys) system; 
        inherit (cfg) usr sys;
        pkgs-stable = (mkPkgsStable cfg.sys.system);
      };
    in 
      args;

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
        extraSpecialArgs = mkArgs cfg;
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
