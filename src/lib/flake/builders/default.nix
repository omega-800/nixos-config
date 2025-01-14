{ inputs }:
{
  inherit (import ./app.nix { inherit inputs; }) mapApps;
  inherit (import ./pkg.nix { inherit inputs; }) mapPkgs;
  inherit (import ./home.nix { inherit inputs; }) mapHomes;
  inherit (import ./host.nix { inherit inputs; }) mapHosts;
  inherit (import ./generic.nix { inherit inputs; }) mapGenerics;
  inherit (import ./droid.nix { inherit inputs; }) mapDroids;
  inherit (import ./iso.nix { inherit inputs; }) mapIsos;
  inherit (import ./deploy.nix { inherit inputs; }) mapDeployments;
  inherit (import ./format.nix { inherit inputs; }) mapFormatters;
  inherit (import ./check.nix { inherit inputs; }) mapChecks;
  inherit (import ./shell.nix { inherit inputs; }) mapShells;
}
