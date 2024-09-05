{ inputs, ... }:
with builtins;
let
  util = import ./util.nix { inherit inputs; };
  pkgsUtil = import ./pkgs.nix { inherit inputs; };
  script = import ./sys_script.nix { inherit inputs; };
in
rec {
  inherit (util) mkCfg mkArgs mkGlobals;
  inherit (pkgsUtil) mkPkgs mkHomeMgr mkOverlays;
  inherit (script) writeCfgToScript generateInstallerList;

  mkModules = hackyLib: profile: path: attrs: type: [
    # ({
    #   # clearly i do NOT understand how nix works
    #   #nixpkgs.overlays = [ inputs.nur.overlay ];
    #   nixpkgs.overlays = mkOverlays cfg.sys.genericLinux;
    # })
    ../profiles/default/${type}.nix
    ../profiles/${profile}/${type}.nix
    (import "${path}/${type}.nix")
    (inputs.nixpkgs-unstable.lib.filterAttrs (n: v: !elem n [ "system" ]) attrs)
  ];

  mkHost = path: attrs:
    let
      cfg = mkCfg path;
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
    in
    inputs.nixpkgs-unstable.lib.nixosSystem {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules =
        mkModules pkgsFinal.lib cfg.sys.profile path attrs "configuration";
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
      modules = mkModules pkgsFinal.lib cfg.sys.profile path attrs "home";
    };

  mapHomes = dir: attrs: mapHostConfigs dir "home" (path: mkHome path attrs);

  mkGeneric = path: attrs:
    let cfg = mkCfg path;
    in systemConfigs {
      inherit (cfg.sys) system;
      specialArgs = mkArgs cfg;
      modules =
        mkModules pkgsFinal.lib cfg.sys.profile path attrs "configuration";
    };

  mapGeneric = dir: attrs:
    mapHostConfigs dir "configuration" (path: mkGeneric path attrs);

  mapHostConfigs = dir: type: fn:
    with inputs.nixpkgs.lib;
    filterAttrs (n: v: v != null && !(hasPrefix "_" n)) (mapAttrs'
      (n: v:
        let path = "${toString dir}/${n}";
        in if v == "directory" && pathExists "${path}/${type}.nix"
          && pathExists "${path}/config.nix" then
          nameValuePair n (fn path)
        else
          nameValuePair "" null)
      (readDir dir));

  mapModules = dir: fn:
    with inputs.nixpkgs-stable.lib;
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
