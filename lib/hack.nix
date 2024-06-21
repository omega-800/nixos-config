{ inputs, pkgs, lib, ... }: 
with lib;
with builtins; 
let
  pkgsUtil = import ./pkgs.nix { inherit inputs pkgs lib; };
in rec {
  inherit (pkgsUtil) isStable mkPkgsStable mkHomeMgr mkPkgs;

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
}
