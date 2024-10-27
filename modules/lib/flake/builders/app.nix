{ inputs }:
let
  inherit (import ../utils { inherit inputs; }) mkPkgs importModule PATHS;
  inherit (import (PATHS.LIBS + /omega/dirs.nix) {
    inherit (inputs.nixpkgs-unstable) lib;
  })
    mapFilterDir;
in {
  mapAppsByArch = architectures:
    let
      dir = PATHS.MODULES + /apps;
      inherit (inputs.nixpkgs-unstable.lib)
        removeSuffix last splitString hasSuffix hasPrefix pathExists;
    in inputs.nixpkgs-unstable.lib.genAttrs architectures (arch:
      mapFilterDir (path:
        if (hasSuffix ".sh" path) then {
          type = "app";
          program = let
            name = removeSuffix ".sh" (last (splitString "/" path));
            script = (mkPkgs false arch false).writeShellScriptBin name
              (builtins.readFile path);
          in "${script}/bin/${name}";
        } else
          (importModule path arch { })) (n: v:
            !(hasPrefix "_" n) && ((v == "directory"
              && pathExists "${toString dir}/${n}/default.nix")
              || (v == "regular" && (hasSuffix ".sh" n || hasSuffix ".nix" n))))
      dir);
}
