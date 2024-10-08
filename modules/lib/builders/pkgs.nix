{ inputs, ... }: rec {
  mkOverlays = isStable: system: isGenericLinux:
    [
      inputs.lonsdaleite.overlays.lonsdaleite
      inputs.deploy-rs.overlay
      (self: super: {
        deploy-rs = {
          inherit (import (getPkgsFlake isStable) { inherit system; })
            deploy-rs;
          lib = super.deploy-rs.lib;
        };
      })
    ] ++ (if isStable then
      [ ]
    else [
      inputs.rust-overlay.overlays.default
      inputs.nur.overlay
    ]) ++ (if isGenericLinux then [ inputs.nixgl.overlay ] else [ ]);

  getHomeMgrFlake = isStable:
    inputs."home-manager-${if isStable then "" else "un"}stable";

  getPkgsFlake = isStable:
    inputs."nixpkgs-${if isStable then "" else "un"}stable";

  mkPkgs = isStable: system: isGenericLinux:
    (import (getPkgsFlake isStable) {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnfreePredicate = (_: true);
      };
      overlays = mkOverlays isStable system isGenericLinux;
    });
}
