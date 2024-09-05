{ inputs, ... }:
with inputs.nixpkgs-unstable.lib; rec {
  mkOverlays = genericLinux:
    [
      # inputs.rust-overlay.overlays.default
      inputs.nur.overlay
    ] ++ (if genericLinux then [ inputs.nixgl.overlay ] else [ ]);

  mkPkgsStable = system:
    let
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };
    in
    pkgs-stable;

  mkPkgsUnstable = system: genericLinux:
    let
      pkgs-unstable = (import nixpkgs-patched {
        system = system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
        overlays = mkOverlays genericLinux;
      });
      nixpkgs-patched =
        (import inputs.nixpkgs { inherit system; }).applyPatches {
          name = "nixpkgs-patched";
          src = inputs.nixpkgs;
        };
    in
    pkgs-unstable;

  mkPkgs = stable: system: genericLinux:
    let
      pkgs-stable = mkPkgsStable system;
      pkgs-unstable = mkPkgsUnstable system genericLinux;
      pkgs = if stable then pkgs-stable else pkgs-unstable;
    in
    pkgs;

}
