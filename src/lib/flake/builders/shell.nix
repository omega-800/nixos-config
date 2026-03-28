{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib) mkMerge genAttrs;
  inherit (import ../utils/vars.nix) PATHS SYSTEMS;
in
{
  # NOTE: the fuck did i do here
  mapShells = genAttrs SYSTEMS (
    system:
    let
      omega = inputs.nixpkgs-unstable.legacyPackages.${system}.mkShell {
        inherit (inputs.self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = inputs.self.checks.${system}.pre-commit-check.enabledPackages;
        packages = with inputs.nixpkgs-unstable.legacyPackages.${system}; [
          nixd
          nixfmt
        ];
      };
    in
    {
      inherit omega;
      default = omega;
    }
  );
}
