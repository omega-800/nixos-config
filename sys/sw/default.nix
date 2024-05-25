{ ... }: {
  imports = [
    #./docker.nix
    ./os.nix
    ./shell.nix
    ./virtualization.nix
  ];
}
