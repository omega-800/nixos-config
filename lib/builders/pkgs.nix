{ inputs, ... }: rec {
  mkOverlays = isGenericLinux: isStable:
    if isStable then
      [ ]
    else
      [
        # inputs.rust-overlay.overlays.default
        inputs.nur.overlay
      ] ++ (if isGenericLinux then [ inputs.nixgl.overlay ] else [ ]);

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
      overlays = mkOverlays isGenericLinux isStable;
    });
}
