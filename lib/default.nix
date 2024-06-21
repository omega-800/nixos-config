{ inputs, pkgs, lib, ... }: 
let
  builders = import ./builders.nix { inherit inputs pkgs lib; };
in {
  inherit (builders) mkHost mkHome;
}
