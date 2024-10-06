{ inputs, ... }:
let
  pkgUtil = import ./pkgs.nix { inherit inputs; };
  myLib = import ../my/default.nix {
    pkgs = inputs.nixpkgs-unstable;
    inherit (inputs.nixpkgs-unstable) lib;
  };
in
rec {
  inherit (pkgUtil) mkPkgs mkOverlays getPkgsFlake getHomeMgrFlake;
  inherit (myLib.cfg) getCfgAttr;

  mkCfg = path:
    let
      hostname = with inputs.nixpkgs-unstable.lib; last (splitString "/" path);
      profileCfg = ../../profiles/${getCfgAttr path "sys" "profile"}/config.nix;
    in
    (inputs.nixpkgs-unstable.lib.evalModules {
      modules = [
        {
          config = {
            _module.args = {
              pkgs = mkPkgs (getCfgAttr path "sys" "stable")
                (getCfgAttr path "sys" "system")
                (getCfgAttr path "sys" "genericLinux");
            };
            c.sys.hostname = hostname;
          };
        }
        ../../profiles/default/options.nix
        (import "${path}/config.nix")
      ] ++ (if inputs.nixpkgs-unstable.lib.pathExists profileCfg then
        [ profileCfg ]
      else
        [ ]);
    }).config.c;

  mkModules = cfg: path: attrs: type: [
    {
      nixpkgs.overlays =
        mkOverlays cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
    }
    ../../profiles/default/${type}.nix
    ../../profiles/${cfg.sys.profile}/${type}.nix
    (import "${path}/${type}.nix")
    (inputs.nixpkgs-unstable.lib.filterAttrs
      (n: v: !builtins.elem n [ "system" "hostName" ])
      attrs)
  ];

  mkLib = cfg:
    let
      homeMgr = getHomeMgrFlake cfg.sys.stable;
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      lib = pkgsFinal.lib.extend (final: prev:
        {
          my = import ../my {
            inherit inputs;
            pkgs = pkgsFinal;
            lib = final;
          };
          # nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
          # templateFile = import ./templating.nix { inherit pkgs; };
        } // homeMgr.lib);
    in
    lib;

  mkArgs = cfg:
    let
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      myLib = mkLib cfg;
    in
    {
      inherit inputs;
      inherit (cfg) usr sys;
      # nixpkgs = finalPkgs;
      # pkgs = finalPkgs;
      lib = myLib;
      globals = (import ../../profiles/default/globals.nix {
        inherit (cfg) usr sys;
        lib = myLib;
        pkgs = pkgsFinal;
      });
    };
}
