{ ... }: {
  imports = [
    #./docker.nix
    ./os.nix
    ./stylix.nix
    ./shell.nix
    ./virtualization.nix
    ./env.nix
  ];
}
