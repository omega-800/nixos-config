{ inputs, pkgs, lib, ... }:
with lib;
let pkgUtil = import ./pkgs.nix { inherit inputs pkgs lib; };
in rec {
  inherit (pkgUtil) mkPkgsStable mkPkgs mkHomeMgr mkOverlays;

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
      hackyPkgs = mkPkgs (getCfgAttr path "sys" "stable")
        (getCfgAttr path "sys" "system")
        (getCfgAttr path "sys" "genericLinux");
      cfg = evalModules {
        modules = let 
profileCfg = ../profiles/${getCfgAttr path "sys" "profile"}/config.nix;
in [
          ({ config, ... }: { config._module.args = { pkgs = hackyPkgs; }; })
          ../profiles/default/options.nix
          (import "${path}/config.nix")
        ] ++ (if pathExists profileCfg then [ profileCfg ] else []);
      };
    in
    cfg.config.c;

  mkSysCfg = path:
    let
      #hackyPkgs = hackyHackHackToEvaluateProfileBeforeEvaluatingTheWholeConfigBecauseItDependsOnThePackageVersionDependingOnTheProfile path;
      sysCfgPath =
        "/profiles/${getCfgAttr path "sys" "profile"}/configuration.nix";
      cfg = evalModules {
        modules = [
          ../profiles/default/configuration.nix
          (import (../. + sysCfgPath))
        ];
      };
    in
    cfg.config;

  mkLib = pkgs: cfg: {
    nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
    templateFile = import ./templating.nix { inherit pkgs; };
  };

  mkArgs = cfg:
    let
      args = {
        inherit inputs;
        #inherit (cfg.sys) system; 
        inherit (cfg) usr sys;
        myLib = mkLib pkgs config;
        globals = (import ../profiles/default/globals.nix {
          inherit (cfg) usr sys;
          inherit pkgs lib;
        });
        pkgs-stable = (mkPkgsStable cfg.sys.system);
      };
    in
    args;
}
