{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib) mkMerge genAttrs;
  inherit (import ../utils { inherit inputs; })
    mkPkgs
    mapModules
    PATHS
    SYSTEMS
    ;
in
{
  mapChecks =
    (builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks inputs.self.deploy
    ) inputs.deploy-rs-unstable.lib)
    // (genAttrs SYSTEMS (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = PATHS.ROOT;
        hooks = {
          nixpkgs-fmt.enable = false;
          nixfmt-rfc-style.enable = true;
        };
      };
    }
    # // (mapModules (
    #   path:
    #   (mkPkgs false system false).callPackage path {
    #     # system = arch;
    #   }
    # ) PATHS.CHECKS)
    ));
}
