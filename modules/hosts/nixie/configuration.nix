{ inputs, config, lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ...
    # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    inputs.nixos-hardware.nixosModules.hp-elitebook-830g6
  ];
#FIXME: breaks my insecurities
m.sec.enable = lib.mkForce false;
  nixpkgs.config = {
    allowUnfreePredicate = _: true;
    allowUnfree = true;
    allowBroken = true;
  };
  # for building the system remotely (because pi's RAM isn't enough)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "23.11";
}
