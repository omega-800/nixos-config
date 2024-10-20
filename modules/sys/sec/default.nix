{ lib, inputs, ... }: {
  # testing 
  imports = [
    # TODO: add as soon as it's finished
    # inputs.lonsdaleite.nixosModules.lonsdaleite 
    ./sops.nix
    ./gpg.nix
  ];

  #  config.lonsdaleite.enable = false;
}
