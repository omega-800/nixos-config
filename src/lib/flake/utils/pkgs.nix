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
    ;
in
rec {
  mkOverlays =
    isStable: system: isGenericLinux:
    [
      (_: _: inputs.self.packages.${system})
      (getInput "nur" isStable).overlays.default
      # (getInput "openconnect-sso" isStable).overlay
    ]
    ++ (optionals (!isStable) [
      inputs.rust-overlay.overlays.default
    ])
    ++ (optionals isGenericLinux [ (getInput "nixgl" isStable).overlay ]);

  mkInputs =
    isStable:
    mapAttrs' (n: nameValuePair (rmSuffix "-unstable" (rmSuffix "-stable" n))) (
      filterAttrs (
        n: _:
        (isStable && hasSuffix "-stable" n)
        || (!isStable && hasSuffix "-unstable" n)
        || ((!hasSuffix "-stable" n) && (!hasSuffix "-unstable" n))
      ) inputs
    );

  getInput = name: isStable: inputs."${name}-${if isStable then "" else "un"}stable";

  getPkgsInput = getInput "nixpkgs";

  getHomeMgrInput = getInput "home-manager";

  mkPkgs =
    isStable: system: isGenericLinux:
    (import (getPkgsInput isStable) {
      inherit system;
      config = { };
      overlays = mkOverlays isStable system isGenericLinux;
    });
}
