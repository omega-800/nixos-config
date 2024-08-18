{ inputs, pkgs, lib, ... }:
with lib; rec {
  isStable = profile: profile == "never"; # because this breaks home-manager

  mkLib = cfg:
    let
      stablePkgs = isStable cfg.sys.profile;
      lib = (if stablePkgs then
        inputs.nixpkgs-stable.lib
      else
        inputs.nixpkgs.lib).extend (self: super: {
        my = import ./lib {
          inherit pkgs inputs;
          lib = self;
        };
      });
    in
    lib;

  mkHomeMgr = cfg:
    let
      stablePkgs = isStable cfg.sys.profile;
      home-manager = (if stablePkgs then
        inputs.home-manager-stable
      else
        inputs.home-manager-unstable);
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

  mkOverlays = genericLinux:
    [ inputs.rust-overlay.overlays.default inputs.nur.overlay ]
    ++ (if genericLinux then [ inputs.nixgl.overlay ] else [ ]);

  mkPkgsUnstable = system: genericLinux:
    let
      pkgs-unstable = (import nixpkgs-patched {
        system = system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = mkOverlays genericLinux;
      });
      nixpkgs-patched =
        (import inputs.nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };
    in
    pkgs-unstable;

  mkPkgs = profile: system: genericLinux:
    let
      stablePkgs = isStable profile;
      pkgs-stable = mkPkgsStable system;
      pkgs-unstable = mkPkgsUnstable system genericLinux;
      pkgs = if stablePkgs then pkgs-stable else pkgs-unstable;
    in
    pkgs;

}
