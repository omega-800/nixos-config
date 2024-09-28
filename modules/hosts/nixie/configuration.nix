{ inputs, config, lib, pkgs, ... }: {
  modules = [
    # ...
    # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    inputs.nixos-hardware.nixosModules.hp-elitebook-830g6
  ];
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # for building the system remotely (because pi's RAM isn't enough)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings.extra-platforms = config.boot.binfmt.emulatedSystems;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11";
}
