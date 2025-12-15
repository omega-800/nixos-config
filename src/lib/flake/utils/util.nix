{ inputs }:
let
  inherit (import ./vars.nix) CONFIGS PATHS;
  inherit (PATHS)
    PROFILES
    LIBS
    NODES
    M_OMEGA
    ;
  inherit (inputs.nixpkgs-unstable) lib;
  inherit
    ((import (LIBS + /omega) {
      pkgs = inputs.nixpkgs-unstable;
      # FIXME: hacky
      sys = { };
      usr = { };
      net = { };
      inherit lib;
    }).cfg
    )
    getCfgAttr
    mkCfgModules
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
      profile = getCfgAttr hostname "sys" "profile";
      stable = getCfgAttr hostname "sys" "stable";
      system = getCfgAttr hostname "sys" "system";
      genericLinux = getCfgAttr hostname "sys" "genericLinux";
      profileCfg = PROFILES + /${profile}/${CONFIGS.omega}.nix;
    in
    (lib.evalModules {
      modules = [
        {
          config._module.args.pkgs = mkPkgs stable system genericLinux;
        }
      ]
      ++ (mkCfgModules hostname)
      ++ (lib.optionals (lib.pathExists profileCfg) [ profileCfg ]);
    }).config.c;

  mkModules =
    cfg: type:
    let
      inherit (cfg.sys)
        stable
        system
        genericLinux
        profile
        ;
      inherit (cfg.net) hostname;
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
        final: _:
        {
          omega = import (LIBS + /omega) {
            inherit inputs;
            # FIXME: hacky
            inherit (cfg) sys usr net;
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
      inherit (cfg) usr sys net;
      # nixpkgs = finalPkgs;
      # pkgs = finalPkgs;
      lib = myLib;
      globals = import (M_OMEGA + /globals.nix) {
        inherit (cfg) usr sys net;
        lib = myLib;
        pkgs = pkgsFinal;
        inherit (import ./vars.nix) PATHS CONFIGS;
      };
      inherit (import ./vars.nix) PATHS CONFIGS;
    };
}
