{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.u.nixGLPrefix = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = ''
      Will be prepended to commands which require working OpenGL.

      This needs to be set to the right nixGL package on non-NixOS systems.
    '';
  };
  config.nixpkgs.overlays = [
    (final: prev: {
      nixGL = import ./nixGL.nix {
        inherit config;
        pkgs = prev;
      };
    })
  ];
}
