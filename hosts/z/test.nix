{ pkgs ? import <nixpkgs> { } }:
let
  result = pkgs.lib.evalModules {
    modules = [
      ../../profiles/default/options.nix
      ./config.nix
    ];
  };
in
result.config
