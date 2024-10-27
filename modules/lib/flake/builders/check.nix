{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib) mkMerge genAttrs;
  inherit (import ../utils/vars.nix) PATHS SYSTEMS;

in
{
  mapChecks = mkMerge [
    (builtins.mapAttrs (
      system: deployLib: deployLib.deployChecks inputs.self.deploy
    ) inputs.deploy-rs-unstable.lib)
    (genAttrs SYSTEMS (system: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = PATHS.ROOT;
        hooks.nixpkgs-fmt.enable = true;
      };
    }))
  ];
}
