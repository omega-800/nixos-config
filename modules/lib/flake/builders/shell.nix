{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib) mkMerge genAttrs;
  inherit (import ../utils/vars.nix) PATHS SYSTEMS;

in
{
  mapShells = mkMerge [
    (genAttrs SYSTEMS (system: {
      default = inputs.nixpkgs-unstable.legacyPackages.${system}.mkShell {
        inherit (inputs.self.checks.${system}.pre-commit-check) shellHook;
        buildInputs = inputs.self.checks.${system}.pre-commit-check.enabledPackages;
        packages = with inputs.nixpkgs-unstable.legacyPackages.${system}; [
          nil
          nixfmt-rfc-style
        ];
      };
    }))
  ];
}
