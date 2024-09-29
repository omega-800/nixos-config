{ inputs, ... }:
with builtins;
let
  util = import ./util.nix { inherit inputs; };
  pkgUtil = import ./util.nix { inherit inputs; };
  script = import ./sys_script.nix { inherit inputs; };
  dirsUtil = import ../my/dirs.nix { lib = inputs.nixpkgs-unstable.lib; };
in
rec {
  inherit (util) mkCfg mkArgs mkGlobals mkModules;
  inherit (pkgUtil) mkPkgs mkOverlays getPkgsFlake getHomeMgrFlake;
  inherit (script) writeCfgToScript generateInstallerList;
  inherit (dirsUtil) mapFilterDir;

  mkHost = path: attrs:
    let cfg = mkCfg path;
    in (getPkgsFlake cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      #pkgs = pkgsFinal;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs "configuration" ++ [
        ({ imports, pkgs, modulesPath, ... }: {
          imports =
            [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
        })
      ]; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

  mapHosts = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkHost path attrs);

  mkHome = path: attrs:
    let
      cfg = mkCfg path;
      # ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
      #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
    in
    (getHomeMgrFlake cfg.sys.stable).lib.homeManagerConfiguration {
      pkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      extraSpecialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs "home";
    };

  mapHomes = dir: attrs: mapHostConfigs dir "home" (path: mkHome path attrs);

  mkDroid = path: attrs:
    let
      cfg = mkCfg path;
      extraSpecialArgs = mkArgs cfg;
    in
    inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      pkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      modules =
        [ ../../droid { home-manager = { inherit extraSpecialArgs; }; } ];
      inherit extraSpecialArgs;
    };

  mapDroids = dir: attrs: mapHostConfigs dir "droid" (path: mkDroid path attrs);

  mkGeneric = path: attrs:
    let cfg = mkCfg path;
    in inputs.system-manager.lib.makeSystemConfig {
      #inherit (cfg.sys) system;
      #specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs "configuration";
    };

  mapGeneric = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkGeneric path attrs);

  mapHostConfigs = dir: type: fn:
    with inputs.nixpkgs-unstable.lib;
    mapFilterDir fn
      (n: v:
        v == "directory" && !(hasPrefix "_" n)
        && pathExists "${toString dir}/${n}/${type}.nix")
      dir;

  mapAppsByArch = architectures: args:
    with inputs.nixpkgs-unstable.lib;
    let dir = ../../apps;
    in (builtins.listToAttrs (map
      (arch: {
        name = arch;
        value = mapFilterDir
          (path:
            if (hasSuffix ".sh" path) then {
              type = "app";
              program =
                let
                  name = removeSuffix ".sh" (last (splitString "/" path));
                  script = (mkPkgs false arch false).writeShellScriptBin name
                    (builtins.readFile path);
                in
                "${script}/bin/${name}";
            } else
              (importModule path arch args))
          (n: v:
            !(hasPrefix "_" n) && ((v == "directory"
            && pathExists "${toString dir}/${n}/default.nix")
            || (v == "regular" && (hasSuffix ".sh" n || hasSuffix ".nix" n))))
          dir;
      })
      architectures));

  mapModulesByArch = dir: architectures: args:
    (builtins.listToAttrs (map
      (arch: {
        name = arch;
        value = mapModules (path: importModule path arch args) dir;
      })
      architectures));

  importModule = path: arch: args:
    (import path (rec {
      system = arch;
      pkgs = mkPkgs false arch false;
      inherit (pkgs) lib;
    } // args));

  mapModules = fn: dir:
    with inputs.nixpkgs-unstable.lib;
    mapFilterDir fn
      (n: v:
        !(hasPrefix "_" n)
        && ((v == "directory" && pathExists "${toString dir}/${n}/default.nix")
        || (v == "regular" && n != "default.nix" && n != "flake.nix"
        && (hasSuffix ".nix" n))))
      dir;
}
