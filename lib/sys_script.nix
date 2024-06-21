{ pkgs, lib, config, ... }:
let
  iamstupidandthatisokay = import ./hackyhackhack.nix { inherit inputs outputs stateVersion; };
  cfg = lib.evalModules {
    modules = [
      ({config, ...}: {config._module.args = {pkgs = hackyPkgs;};})
      ../profiles/default/options.nix
      (import "${path}/config.nix")
    ];
  };
in {
  home.file."system_installer.sh" = {
    executable = true;
    text = ''
#!${pkgs.bash}
    ${
      lib.mapAttrsToList (n: v: ''${n}="${v}"'') config.environment.sessionVariables
    }
    '';
  };
}
