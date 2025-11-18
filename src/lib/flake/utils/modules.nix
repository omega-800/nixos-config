{ inputs }:
let
  inherit ((import ./vars.nix).PATHS) NODES LIBS;
  inherit
    (import (LIBS + /omega/dirs.nix) {
      inherit (inputs.nixpkgs-unstable) lib;
    })
    mapFilterDir
    mapFilterDir'
    ;
  inherit (import ./pkgs.nix { inherit inputs; }) mkPkgs;
  inherit (inputs.nixpkgs-unstable.lib)
    removeSuffix
    last
    splitString
    hasSuffix
    hasPrefix
    pathExists
    ;
in
rec {
  #TODO: rename
  hasHostConfig =
    dir: type:
    (n: v: v == "directory" && !(hasPrefix "_" n) && pathExists "${toString dir}/${n}/${type}.nix");

  mapHostConfigs = type: fn: mapFilterDir' fn (hasHostConfig NODES type) NODES;

  mapModulesByArch =
    dir: architectures: args:
    inputs.nixpkgs-unstable.lib.genAttrs architectures (
      arch: mapModules (path: importModule path arch args) dir
    );

  importModule =
    path: system: args:
    (import path (
      let
        pkgs = mkPkgs false system false;
      in
      {
        inherit system pkgs;
        inherit (pkgs) lib;
      }
      // args
    ));

  mkScriptBin =
    arch: path:
    let
      name = removeSuffix ".sh" (last (splitString "/" path));
    in
    (mkPkgs false arch false).writeScript name (builtins.readFile path);

  mapScriptsOrModules =
    fn: dir:
    mapFilterDir fn (
      n: v:
      !(hasPrefix "_" n)
      && (
        (v == "directory" && pathExists "${toString dir}/${n}/default.nix")
        || (v == "regular" && (hasSuffix ".sh" n || hasSuffix ".nix" n))
      )
    ) dir;

  mapModules =
    fn: dir:
    mapFilterDir fn (
      n: v:
      !(hasPrefix "_" n)
      && (
        (v == "directory" && pathExists "${toString dir}/${n}/default.nix")
        || (v == "regular" && n != "default.nix" && n != "flake.nix" && (hasSuffix ".nix" n))
      )
    ) dir;
}
