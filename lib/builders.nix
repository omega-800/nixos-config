{ inputs, pkgs, lib, ... }:
with lib;
with builtins;
let
  util = import ./util.nix { inherit inputs pkgs lib; };
  script = import ./sys_script.nix { inherit inputs pkgs lib; };
in
rec {
  inherit (util)
    mkCfg mkArgs mkPkgs mkPkgsStable mkOverlays mkGlobals mkHomeMgr;
  inherit (script) writeCfgToScript generateInstallerList;

  mkModules = cfg: path: attrs: type:
      [
        ({
          # clearly i do NOT understand how nix works
          nixpkgs.overlays = [ inputs.nur.overlay ];
        })
        ../profiles/default/${type}.nix
        ../profiles/${cfg.sys.profile}/${type}.nix
        (import "${path}/${type}.nix")
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
      ];

  mkHost = path: attrs:
    let
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      cfg = mkCfg path;
    in
    nixosSystem {
      inherit (cfg.sys) system;
      #pkgs = pkgsFinal;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs "configuration";
      };

  mapHosts = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkHost path attrs);

  mkHome = path: attrs:
    let
      cfg = mkCfg path;
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      home-manager = mkHomeMgr cfg;
      args = mkArgs cfg;
      # ok so calling mkArgs does not work because it causes infinite recursion of usr attr set?? bc mkConfig's usr is being passed to mkArgs as well as writeCfgToScript???? but usr isn't even used in writeCfgToScript????????? i am brain hurty
      #extraSpecialArgs = mkMerge [(mkArgs cfg) { genericLinuxSystemInstaller = writeCfgToScript cfg; } ];
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFinal;
      extraSpecialArgs = args;
      modules = mkModules cfg path attrs "home";
    };

  mapHomes = dir: attrs: mapHostConfigs dir "home" (path: mkHome path attrs);

  mkGeneric = path: attrs:
    let cfg = mkCfg path;
    in systemConfigs {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules = mkModules cfg path attrs "configuration";
    };

  mapGeneric = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkGeneric path attrs);

  mapHostConfigs = dir: type: fn:
    filterAttrs (n: v: v != null && !(hasPrefix "_" n)) (mapAttrs'
      (n: v:
        let path = "${toString dir}/${n}";
        in if v == "directory" && pathExists "${path}/${type}.nix" then
          nameValuePair n (fn path)
        else
          nameValuePair "" null)
      (readDir dir));

  mapModules = dir: fn:
    filterAttrs (n: v: v != null && !(hasPrefix "_" n)) (mapAttrs'
      (n: v:
        let path = "${toString dir}/${n}";
        in if v == "directory" && pathExists "${path}/default.nix" then
          nameValuePair n (fn path)
        else if v == "regular" && n != "default.nix" && n != "flake.nix"
          && hasSuffix ".nix" n then
          nameValuePair (removeSuffix ".nix" n) (fn path)
        else
          nameValuePair "" null)
      (readDir dir));
}
