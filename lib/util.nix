{ inputs, pkgs, lib, ... }:
with lib;
let pkgUtil = import ./pkgs.nix { inherit inputs pkgs lib; };
in rec {
  inherit (pkgUtil) mkPkgsStable mkPkgs mkOverlays;

  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr = path: type: name:
    let
      cfg = evalModules {
        modules =
          [ ../profiles/default/options.nix (import "${path}/config.nix") ];
      };
    in
    cfg.config.c.${type}.${name};

  mkCfg = path:
    let
      #hackyPkgs = hackyHackHackToEvaluateProfileBeforeEvaluatingTheWholeConfigBecauseItDependsOnThePackageVersionDependingOnTheProfile path;
      hackyPkgs =
        mkPkgs (getCfgAttr path "sys" "stable") (getCfgAttr path "sys" "system")
          (getCfgAttr path "sys" "genericLinux");
      cfg = evalModules {
        modules =
          let
            profileCfg =
              ../profiles/${getCfgAttr path "sys" "profile"}/config.nix;
          in
          [
            ({ config, ... }: { config._module.args = { pkgs = hackyPkgs; }; })
            ../profiles/default/options.nix
            (import "${path}/config.nix")
          ] ++ (if pathExists profileCfg then [ profileCfg ] else [ ]);
      };
    in
    cfg.config.c;

  mkHomeMgr = cfg: (if cfg.sys.stable then
        inputs.home-manager-stable
      else
        inputs.home-manager-unstable);

  mkLib = cfg:
    let
      home-manager = mkHomeMgr cfg;
      lib = (if cfg.sys.stable then
        inputs.nixpkgs-stable
      else
        inputs.nixpkgs).lib.extend (final: prev: {
        my = import ./. {
          inherit pkgs inputs;
          lib = final;
        };
        # nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
        # templateFile = import ./templating.nix { inherit pkgs; };
      } // home-manager.lib);
    in
    lib;

  # nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

  mkArgs = cfg:
    let
        finalPkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      args = {
        inherit inputs;
        #inherit (cfg.sys) system; 
        inherit (cfg) usr sys;
        nixpkgs =finalPkgs;
        pkgs =finalPkgs;
        lib = mkLib cfg;
        globals = (import ../profiles/default/globals.nix {
          inherit (cfg) usr sys;
          inherit pkgs lib;
        });
        # pkgs-stable = (mkPkgsStable cfg.sys.system);
      };
    in
    args;
}
