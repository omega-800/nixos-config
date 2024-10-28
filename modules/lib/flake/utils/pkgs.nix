{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib)
    mapAttrs' hasSuffix nameValuePair filterAttrs;
  inherit (import ../../omega/str.nix {
    inherit (inputs.nixpkgs-unstable) lib;
  })
    rmSuffix rmPrefix;
in
rec {
  mkOverlays = isStable: system: isGenericLinux:
    [
      (getInput "deploy-rs" isStable).overlay
      (self: super: {
        deploy-rs = {
          inherit (mkPkgs isStable system isGenericLinux) deploy-rs;
          inherit (super.deploy-rs) lib;
        };
      })
      (self: super: inputs.self.packages.${system})
    ] ++ (if isStable then
      [ ]
    else [
      inputs.rust-overlay.overlays.default
      inputs.nur.overlay
    ]) ++ (if isGenericLinux then
      [ (getInput "nixgl" isStable).overlay ]
    else
      [ ]);

  mkInputs = isStable:
    mapAttrs'
      (n: v: nameValuePair (rmSuffix "-unstable" (rmSuffix "-stable" n)) v)
      (filterAttrs
        (n: v:
          (isStable && (hasSuffix "-stable" n))
          || (!isStable && hasSuffix "-unstable" n)
          || ((!hasSuffix "-stable" n) && (!hasSuffix "-unstable" n)))
        inputs);

  getInput = name: isStable:
    inputs."${name}-${if isStable then "" else "un"}stable";

  getPkgsInput = isStable: getInput "nixpkgs" isStable;

  getHomeMgrInput = isStable: getInput "home-manager" isStable;

  mkPkgs = isStable: system: isGenericLinux:
    (import (getPkgsInput isStable) {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = mkOverlays isStable system isGenericLinux;
    });
}
