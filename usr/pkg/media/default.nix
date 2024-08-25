{ usr, lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.u.media.spicetify;
  inherit (inputs) spicetify-nix;
in
{
  options.u.media.spicetify.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable;
  };

  imports = [
    ./media.nix
    ./newsboat.nix
    ./mpd.nix
    spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    /* # i don't think this is needed?
       # allow spotify to be installed if you don't have unfree enabled already
       nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
       "spotify"
       ];
    */
    programs = {
      spicetify =
        import ./spicetify.nix pkgs config.lib.stylix.colors spicetify-nix;
    };
  };
}
