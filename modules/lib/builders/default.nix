{ inputs, ... }:
with builtins;
let
  util = import ./util.nix { inherit inputs; };
  pkgUtil = import ./pkgs.nix { inherit inputs; };
  deployUtil = import ./deploy.nix { inherit inputs; };
  script = import ./sys_script.nix { inherit inputs; };
  dirsUtil = import ../my/dirs.nix { lib = inputs.nixpkgs-unstable.lib; };
in
rec {
  inherit (util) mkCfg mkArgs mkGlobals mkModules;
  inherit (pkgUtil) mkPkgs mkOverlays getPkgsFlake getHomeMgrFlake;
  inherit (script) writeCfgToScript generateInstallerList;
  inherit (dirsUtil) mapFilterDir;
  inherit (deployUtil) mapDeployments mapNodes mapProfiles;

  CONFIGS = {
    homeConfigurations = "home";
    nixosConfigurations = "configuration";
    nixOnDroidConfigurations = "droid";
    #TODO: change
    systemConfigs = "configuration";
  };

  # looks like redundant shitty code? because it is. too tired to rewrite it. if somebody starts paying me for this i might  

  mkHost = path: attrs:
    let cfg = mkCfg path;
    in (getPkgsFlake cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs
        CONFIGS.nixosConfigurations; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

  mkIso = path: attrs:
    let cfg = mkCfg path;
    in (getPkgsFlake cfg.sys.stable).lib.nixosSystem {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules = (mkModules cfg path attrs CONFIGS.nixosConfigurations) ++ [
        ({ config, modulesPath, ... }: {
          imports =
            [ (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix") ];
          config = {
            disko.enableConfig = false;
            services.btrfs.autoScrub.enable = false;
          };
        })
      ]; # ++ (map (service: ../../sys/srv/${service}.nix) cfg.sys.services);
    };

  mapHosts = dir: attrs:
    let inherit (inputs.nixpkgs-unstable.lib) mapAttrs' nameValuePair;
    in (mapHostConfigs dir CONFIGS.nixosConfigurations
      (path: mkHost path attrs))
    // (mapAttrs' (n: v: nameValuePair "${n}-iso" v)
      (mapHostConfigs dir CONFIGS.nixosConfigurations
        (path: mkIso path attrs)));

  mkHome = path: attrs:
    let
      cfg = mkCfg path;
      # ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
      #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
    in
    (getHomeMgrFlake cfg.sys.stable).lib.homeManagerConfiguration {
      pkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      extraSpecialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs CONFIGS.homeConfigurations;
    };

  mapHomes = dir: attrs:
    mapHostConfigs dir CONFIGS.homeConfigurations (path: mkHome path attrs);

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

  mapDroids = dir: attrs:
    mapHostConfigs dir CONFIGS.nixOnDroidConfigurations
      (path: mkDroid path attrs);

  mkGeneric = path: attrs:
    let cfg = mkCfg path;
    in inputs.system-manager.lib.makeSystemConfig {
      #inherit (cfg.sys) system;
      #specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs CONFIGS.systemConfigs;
    };

  mapGeneric = dir: attrs:
    mapHostConfigs dir CONFIGS.systemConfigs (path: mkGeneric path attrs);

  #TODO: rename
  hasHostConfig = dir: type:
    with inputs.nixpkgs-unstable.lib;
    (n: v:
      v == "directory" && !(hasPrefix "_" n)
      && pathExists "${toString dir}/${n}/${type}.nix");

  mapHostConfigs = dir: type: fn:
    mapFilterDir fn (hasHostConfig dir type) dir;

  mapAppsByArch = architectures: args:
    with inputs.nixpkgs-unstable.lib;
    let dir = ../../apps;
    in inputs.nixpkgs-unstable.lib.genAttrs architectures (arch:
      mapFilterDir
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
        dir);

  mapPkgsByArch = architectures: args:
    let dir = ../../pkgs;
    in inputs.nixpkgs-unstable.lib.genAttrs architectures (arch:
      mapModules
        (path:
          (mkPkgs false arch false).callPackage path {
            # system = arch;
          })
        dir);

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
    mapFilterDir fn
      (n: v:
        !(hasPrefix "_" n)
        && ((v == "directory" && pathExists "${toString dir}/${n}/default.nix")
        || (v == "regular" && n != "default.nix" && n != "flake.nix"
        && (hasSuffix ".nix" n))))
      dir;
}
