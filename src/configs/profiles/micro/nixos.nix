{ inputs, ... }:
{
  imports = [
    ../serv/nixos.nix
    # TODO: flake check fails...
    # inputs.microvm.nixosModules.microvm
  ];
  # microvm = { hypervisor = "qemu"; };
}
