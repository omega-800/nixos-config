{ inputs, ... }:
{
  imports = [
    ../serv/nixos.nix
    inputs.microvm.nixosModules.microvm
  ];
  microvm = {
    hypervisor = "qemu";
  };
}
