{ inputs }:
let
  inherit (import ./vars.nix) CONFIGS PATHS;
  inherit (PATHS) PROFILES LIBS NODES;
  inherit (inputs.nixpkgs-unstable) lib;
  inherit
    ((import (LIBS + /omega) {
      pkgs = inputs.nixpkgs-unstable;
      inherit lib;
    }).cfg
    )
    getCfgAttr
    ;

  inherit (import ./pkgs.nix { inherit inputs; })
    mkPkgs
    mkOverlays
    getHomeMgrInput
    mkInputs
    ;
in
rec {
  mkCfg =
    hostname:
    let
      profileCfg = PROFILES + /${getCfgAttr hostname "sys" "profile"}/${CONFIGS.omega}.nix;
    in
    (lib.evalModules {
      modules = [
        {
          config = {
            _module.args = {
              pkgs = mkPkgs (getCfgAttr hostname "sys" "stable") (getCfgAttr hostname "sys" "system") (
                getCfgAttr hostname "sys" "genericLinux"
              );
              inherit (import ./vars.nix) PATHS CONFIGS;
            };
            c.sys.hostname = hostname;
          };
        }
        (PROFILES + /default/options.nix)
        (NODES + /${hostname}/${CONFIGS.omega}.nix)
      ] ++ (lib.optionals (lib.pathExists profileCfg) [ profileCfg ]);
    }).config.c;

  mkModules =
    cfg: type:
    let
      inherit (cfg.sys)
        stable
        system
        genericLinux
        profile
        hostname
        ;
    in
    [
      { nixpkgs.overlays = mkOverlays stable system genericLinux; }
      (PROFILES + /default/${type}.nix)
      (PROFILES + /${profile}/${type}.nix)
      (NODES + /${hostname}/${type}.nix)
      # (inputs.nixpkgs-unstable.lib.filterAttrs
      #   (n: v: !builtins.elem n [ "system" "hostname" ]) attrs)
    ];

  mkLib =
    cfg:
    let
      inherit (cfg.sys) stable system genericLinux;
      homeMgr = getHomeMgrInput stable;
      pkgsFinal = mkPkgs stable system genericLinux;
      lib = pkgsFinal.lib.extend (
        final: prev:
        {
          omega = import (LIBS + /omega) {
            inherit inputs;
            pkgs = pkgsFinal;
            lib = final;
          };
          # nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
          # templateFile = import ./templating.nix { inherit pkgs; };
        }
        // homeMgr.lib
      );
    in
    lib;

  mkArgs =
    cfg:
    let
      inherit (cfg.sys) stable system genericLinux;
      pkgsFinal = mkPkgs stable system genericLinux;
      myLib = mkLib cfg;
    in
    {
      inputs = mkInputs stable;
      inherit (cfg) usr sys;
      # nixpkgs = finalPkgs;
      # pkgs = finalPkgs;
      lib = myLib;
      globals = import (PROFILES + /default/globals.nix) {
        inherit (cfg) usr sys;
        lib = myLib;
        pkgs = pkgsFinal;
        inherit (import ./vars.nix) PATHS CONFIGS;
      };
      inherit (import ./vars.nix) PATHS CONFIGS;
    };
}
