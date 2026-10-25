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
      # profileCfg = PROFILES + /${profile}/${CONFIGS.omega}.nix;
    in
    (lib.evalModules {
      modules = [
        {
          config._module.args.pkgs = mkPkgs stable system genericLinux;
        }
      ]
      ++ (mkCfgModules hostname)
      ++ (lib.filter lib.pathExists (map (p: PROFILES + /${p}/${CONFIGS.omega}.nix) profile));
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
      # (PROFILES + /${profile}/${type}.nix)
      (NODES + /${hostname}/${type}.nix)
      # (inputs.nixpkgs-unstable.lib.filterAttrs
      #   (n: v: !builtins.elem n [ "system" "hostname" ]) attrs)
    ] ++ (map (p: (PROFILES + /${p}/${type}.nix)) profile);

  # TODO: unslopify
  primaryUser = cfg: {
    profile = cfg.sys.profile;
    stable = cfg.sys.stable;
    uid = cfg.sys.uid;
    usr = cfg.usr;
    extraGroups = [ ];
  };

  allUsers = cfg: [ (primaryUser cfg) ] ++ cfg.users;

  isPrimary = cfg: user: user.usr.username == cfg.usr.username;

  mkLib =
    cfg: user:
    let
      inherit (cfg) sys net;
      inherit (user) usr stable;
      system = sys.system;
      genericLinux = sys.genericLinux;
      pkgsFinal = mkPkgs stable system genericLinux;
    in
    pkgsFinal.lib.extend (
      final: _:
      {
        omega = import (LIBS + /omega) {
          inherit inputs;
          inherit sys usr net;
          pkgs = pkgsFinal;
          lib = final;
        };
      }
      // (getHomeMgrInput stable).lib
    );

  mkUserArgs =
    cfg: user:
    let
      inherit (cfg) sys net;
      inherit (user) usr stable;
      system = sys.system;
      genericLinux = sys.genericLinux;
      pkgsFinal = mkPkgs stable system genericLinux;
      myLib = mkLib cfg user;
    in
    {
      inputs = mkInputs stable;
      inherit usr sys net;
      nixosIntegrated = false;
      lib = myLib;
      globals = import (M_OMEGA + /globals.nix) {
        inherit usr;
        pkgs = pkgsFinal;
        lib = myLib;
        inherit PATHS CONFIGS;
      };
      inherit PATHS CONFIGS;
    };

  mkArgs = cfg: mkUserArgs cfg (primaryUser cfg);

  mkHomeModules =
    cfg: user:
    [ (PROFILES + /default/home.nix) ]
    ++ (map (p: (PROFILES + /${p}/home.nix)) user.profile)
    ++ (lib.optional (isPrimary cfg user) (NODES + /${cfg.net.hostname}/home.nix));
}
