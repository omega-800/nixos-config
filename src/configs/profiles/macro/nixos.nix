{ inputs, ... }:
{
  imports = [
    ../serv/configuration.nix
    inputs.microvm.nixosModules.host
  ];
  microvm = {
    hypervisor = "qemu";
  };
}
