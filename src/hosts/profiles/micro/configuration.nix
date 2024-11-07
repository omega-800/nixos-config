{ inputs, ... }:
{
  imports = [
    ../serv/configuration.nix
    inputs.microvm.nixosModules.microvm
  ];
  microvm = {
    hypervisor = "qemu";
  };
}
