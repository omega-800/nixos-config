{ inputs }:
let
  inherit ((import ./vars.nix).PATHS) MODULES LIBS;
  inherit ((import (LIBS + /omega) {
    pkgs = inputs.nixpkgs-unstable;
    inherit (inputs.nixpkgs-unstable) lib;
  }).cfg)
    getCfgAttr;

  inherit (import ./pkgs.nix { inherit inputs; })
    mkPkgs mkOverlays getHomeMgrInput mkInputs;
in rec {

  mkCfg = path:
    let
      hostname = let inherit (inputs.nixpkgs-unstable.lib) last splitString;
      in last (splitString "/" path);
      profileCfg = MODULES
        + /profiles/${getCfgAttr path "sys" "profile"}/config.nix;
    in (inputs.nixpkgs-unstable.lib.evalModules {
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
        (MODULES + /profiles/default/options.nix)
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
    (MODULES + /profiles/default/${type}.nix)
    (MODULES + /profiles/${cfg.sys.profile}/${type}.nix)
    (import "${path}/${type}.nix")
    (inputs.nixpkgs-unstable.lib.filterAttrs
      (n: v: !builtins.elem n [ "system" "hostname" ]) attrs)
  ];

  mkLib = cfg:
    let
      homeMgr = getHomeMgrInput cfg.sys.stable;
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      lib = pkgsFinal.lib.extend (final: prev:
        {
          omega = import (LIBS + /omega) {
            inherit inputs;
            pkgs = pkgsFinal;
            lib = final;
          };
          # nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
          # templateFile = import ./templating.nix { inherit pkgs; };
        } // homeMgr.lib);
    in lib;

  mkArgs = cfg:
    let
      pkgsFinal = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      myLib = mkLib cfg;
    in {
      inputs = mkInputs cfg.sys.stable;
      inherit (cfg) usr sys;
      # nixpkgs = finalPkgs;
      # pkgs = finalPkgs;
      lib = myLib;
      globals = import (MODULES + /profiles/default/globals.nix) {
        inherit (cfg) usr sys;
        lib = myLib;
        pkgs = pkgsFinal;
      };
    };
}
