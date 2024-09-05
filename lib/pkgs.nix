{ inputs, ... }: rec {
  mkPkgs = stable: system: genericLinux:
    let
      pkgs = import
        (if stable then inputs.nixpkgs-stable else inputs.nixpkgs-unstable)
        {
          inherit system;
          overlays = mkOverlays stable genericLinux;
        };
    in
    pkgs;

  mkHomeMgr = stable:
    inputs."home-manager-${if stable then "" else "un"}stable";

  mkOverlays = stable: genericLinux:
    (if stable then
      [ ]
    else
      [
        # inputs.rust-overlay.overlays.default
        inputs.nur.overlay
      ]) ++ (if genericLinux then [ inputs.nixgl.overlay ] else [ ]);
}
