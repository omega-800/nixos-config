{ inputs }:
let
  inherit (inputs.nixpkgs-unstable.lib) genAttrs;
  inherit (import ../utils/vars.nix) SYSTEMS;
in
{
  mapFormatters = genAttrs SYSTEMS (
    system: inputs.nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style
  );
}
