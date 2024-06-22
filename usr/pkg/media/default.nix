{ pkgs, inputs, ... }: 
let
  inherit (inputs) spicetify-nix;
in {
  imports = [
    ./media.nix
    ./newsboat.nix
    ./mpd.nix
    spicetify-nix.homeManagerModule
  ];
  /*
  # i don't think this is needed?
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];
  */
  programs = {
    spicetify = import ./spicetify.nix pkgs spicetify-nix;
  };
}
