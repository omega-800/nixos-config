{ inputs, pkgs, lib, ...}: 
with lib;
rec {
  isStable = profile: (profile == "homelab" || profile == "worklab"); 

  mkLib = cfg:
    let 
      stablePkgs = isStable cfg.sys.profile;
      lib = (if stablePkgs then inputs.nixpkgs-stable.lib else inputs.nixpkgs.lib).extend
        (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
    in
      lib;

  mkHomeMgr = cfg:
    let
      stablePkgs = isStable cfg.sys.profile;
      home-manager = (if stablePkgs then inputs.home-manager-stable else inputs.home-manager-unstable);
    in
      home-manager;

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
}