{ lib, ... }: with lib; {
  mkHost = path: attrs @ { system ? sys, ... }:
    nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        ../profiles/${attrs.config.c.sys.profile}/configuration.nix
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
