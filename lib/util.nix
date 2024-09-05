{ inputs, ... }:
let pkgUtil = import ./pkgs.nix { inherit inputs; };
in rec {
  inherit (pkgUtil) mkPkgs mkHomeMgr;

  # just don't try to get any attrs which depend on pkgs or you'll encounter that awesome infinite recursion everybody is talking about
  getCfgAttr = path: type: name:
    let
      cfg = inputs.nixpkgs-stable.lib.evalModules {
        modules =
          [ ../profiles/default/options.nix (import "${path}/config.nix") ];
      };
    in
    cfg.config.c.${type}.${name};

  mkCfg = path:
    let
      stable = (getCfgAttr path "sys" "stable");
      system = (getCfgAttr path "sys" "system");
      genericLinux = (getCfgAttr path "sys" "genericLinux");
      profile = (getCfgAttr path "sys" "profile");
      hackyPkgs = mkPkgs stable system genericLinux;
      hackyLib = mkLib stable system genericLinux;
      cfg = hackyLib.evalModules {
        modules =
          let profileCfg = ../profiles/${profile}/config.nix;
          in [
            ({ config, ... }: {
              config._module.args = { pkgs = inputs.nixpkgs-unstable; };
            })
            ../profiles/default/options.nix
            (import "${path}/config.nix")
          ] ++ (if hackyLib.pathExists profileCfg then [ profileCfg ] else [ ]);
      };
    in
    cfg.config.c;

  mkLib = stable: system: genericLinux:
    let
      pkgsFinal = mkPkgs stable system genericLinux;
      home-manager = mkHomeMgr stable;
    in
    pkgsFinal.lib.extend (final: prev:
      {
        my = import ./. {
          inherit inputs;
          pkgs = pkgsFinal;
          lib = final;
        };
        # nixGL = import ../nixGL/nixGL.nix { inherit pkgs cfg; };
        # templateFile = import ./templating.nix { inherit pkgs; };
      } // home-manager.lib);

  # nixpkgs.lib.extend (final: prev: (import ./lib final) // home-manager.lib);

  mkArgs = cfg:
    let
      finalPkgs = mkPkgs cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      finalLib = mkLib cfg.sys.stable cfg.sys.system cfg.sys.genericLinux;
      args = {
        inherit inputs;
        nixpkgs = finalPkgs;
        #pkgs = finalPkgs;

        inherit (cfg) usr sys;
        lib = mkLib cfg;
        globals = (import ../profiles/default/globals.nix {
          inherit (cfg) usr sys;
          lib = finalLib;
          pkgs = finalPkgs;
        });
      };
    in
    args;
}
