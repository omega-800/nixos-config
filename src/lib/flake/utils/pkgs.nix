{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib)
    mapAttrs'
    hasSuffix
    nameValuePair
    filterAttrs
    optionals
    ;
  inherit
    (import ../../omega/str.nix {
      inherit (inputs.nixpkgs-unstable) lib;
    })
    rmSuffix
    rmPrefix
    ;
in
rec {
  mkOverlays =
    isStable: system: isGenericLinux:
    [
      (self: super: inputs.self.packages.${system})
      (getInput "nur" isStable).overlays.default
    ]
    ++ (optionals (!isStable) [
      inputs.rust-overlay.overlays.default
    ])
    ++ (optionals isGenericLinux [ (getInput "nixgl" isStable).overlay ]);

  mkInputs =
    isStable:
    mapAttrs' (n: v: nameValuePair (rmSuffix "-unstable" (rmSuffix "-stable" n)) v) (
      filterAttrs (
        n: v:
        (isStable && (hasSuffix "-stable" n))
        || (!isStable && hasSuffix "-unstable" n)
        || ((!hasSuffix "-stable" n) && (!hasSuffix "-unstable" n))
      ) inputs
    );

  getInput = name: isStable: inputs."${name}-${if isStable then "" else "un"}stable";

  getPkgsInput = isStable: getInput "nixpkgs" isStable;

  getHomeMgrInput = isStable: getInput "home-manager" isStable;

  mkPkgs =
    isStable: system: isGenericLinux:
    (import (getPkgsInput isStable) {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = mkOverlays isStable system isGenericLinux;
    });
}
