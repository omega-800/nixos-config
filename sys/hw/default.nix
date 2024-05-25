{ ... }: {
  imports = [
    ./bluetooth.nix
    ./kernel.nix
    ./opengl.nix
    ./power.nix
    ./printing.nix
    ./systemd.nix
    ./time.nix
  ];
}
