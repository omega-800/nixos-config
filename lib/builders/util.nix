{ inputs, ... }:
let pkgUtil = import ./pkgs.nix { inherit inputs; };
in rec {
  inherit (pkgUtil) mkPkgs mkOverlays getPkgsFlake;

  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr = path: type: name:
    let
      cfg = inputs.nixpkgs-unstable.lib.evalModules {
        modules =
          [ ../../profiles/default/options.nix (import "${path}/config.nix") ];
      };
    in
    cfg.config.c.${type}.${name};

  mkCfg = path:
    let
      hackyPkgs =
        mkPkgs (getCfgAttr path "sys" "stable") (getCfgAttr path "sys" "system")
          (getCfgAttr path "sys" "genericLinux");
      cfg = inputs.nixpkgs-unstable.lib.evalModules {
        modules =
          let
            profileCfg =
              ../../profiles/${getCfgAttr path "sys" "profile"}/config.nix;
          in
          [
            ({ config, ... }: { config._module.args = { pkgs = hackyPkgs; }; })
            ../../profiles/default/options.nix
            (import "${path}/config.nix")
          ] ++ (if inputs.nixpkgs-unstable.lib.pathExists profileCfg then
            [ profileCfg ]
          else
            [ ]);
      };
    in
    cfg.config.c;

  getHomeMgrFlake = stable:
    inputs."home-manager-${if stable then "" else "un"}stable";

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

  # nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

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
