{ inputs, pkgs, lib, ... }: 
with lib; 
with builtins; 
rec {
  mkHost = path: attrs:
    let 
      cfg = evalModules {
        modules = [
          ({config, ...}: {config._module.args = {inherit pkgs;};})
          ../profiles/default/options.nix
          (import "${path}/config.nix")
        ];
      };
      inherit (cfg.config.c.sys) system;
    in
    nixosSystem {
      inherit system;
      specialArgs = { 
        inherit lib inputs system; 
        inherit (cfg.config.c) usr;
      };

      modules = [
        ../profiles/${cfg.config.c.sys.profile}/configuration.nix
        (import "${path}/configuration.nix")
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
      ];
    };

  mapHosts = dir: attrs @ { system ? system, ... }:
    mapHostConfigs dir "configuration" (path: mkHost path attrs);

  mkHome = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        ../profiles/default/configuration.nix
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (filterAttrs (n: v: !elem n [ "system" ]) attrs)
        ../.   # /default.nix
        (import path)
      ];
    };

  mapHomes = dir: attrs @ { system ? system, ... }:
    mapHostConfigs dir "home" (path: mkHome path attrs);

  mapHostConfigs = dir: type: fn:
    filterAttrs 
      (n: v: v != null && !(hasPrefix "_" n))
      (mapAttrs'
        (n: v: 
          let path = "${toString dir}/${n}"; in
          if v == "directory" && pathExists "${path}/${type}.nix"
          then nameValuePair n (fn path)
          else nameValuePait "" null)
        (readDir dir)
      );
}
