{ inputs, pkgs, lib, ...}: 
with lib;
let
  iamstupidandthatisokay = import ./hack.nix { inherit inputs pkgs lib; };
in rec {
  inherit (iamstupidandthatisokay) hackyHackHackToEvaluateProfileBeforeEvaluatingTheWholeConfigBecauseItDependsOnThePackageVersionDependingOnTheProfile mkPkgsStable mkPkgs mkHomeMgr;

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
}
