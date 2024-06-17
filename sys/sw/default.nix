{ ... }: {
  imports = [
    ./docker.nix
    ./os.nix
    ./stylix.nix
    ./shell.nix
    ./virtualization.nix
    ./env.nix
    ./fonts.nix
    ./swhkd.nix
    ./flatpak.nix
    #./dev.nix nevermind that
  ];
}
