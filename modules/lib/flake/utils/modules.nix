{ inputs }:
let
  inherit ((import ./vars.nix).PATHS) HOSTS LIBS;
  inherit (import (LIBS + /omega/dirs.nix) {
    inherit (inputs.nixpkgs-unstable) lib;
  })
    mapFilterDir;
  inherit (import ./pkgs.nix { inherit inputs; }) mkPkgs;
  inherit (inputs.nixpkgs-unstable.lib) hasPrefix pathExists;
in rec {
  #TODO: rename
  hasHostConfig = dir: type:
    (n: v:
      v == "directory" && !(hasPrefix "_" n)
      && pathExists "${toString dir}/${n}/${type}.nix");

  mapHostConfigs = type: fn: mapFilterDir fn (hasHostConfig HOSTS type) HOSTS;

  mapModulesByArch = dir: architectures: args:
    inputs.nixpkgs-unstable.lib.genAttrs architectures
    (arch: mapModules (path: importModule path arch args) dir);

  importModule = path: arch: args:
    (import path (rec {
      system = arch;
      pkgs = mkPkgs false arch false;
      inherit (pkgs) lib;
    } // args));

  mapModules = fn: dir:
    with inputs.nixpkgs-unstable.lib;
    mapFilterDir fn (n: v:
      !(hasPrefix "_" n)
      && ((v == "directory" && pathExists "${toString dir}/${n}/default.nix")
        || (v == "regular" && n != "default.nix" && n != "flake.nix"
          && (hasSuffix ".nix" n)))) dir;
}
