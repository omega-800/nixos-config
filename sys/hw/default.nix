{ ... }: {
  imports = [
    ./audio.nix
    ./automount.nix
    ./bluetooth.nix
    ./boot.nix
    ./kernel.nix
    ./locale.nix
    ./opengl.nix
    ./power.nix
    ./printing.nix
    ./systemd.nix
    ./time.nix
  ];
}
