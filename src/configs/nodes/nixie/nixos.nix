{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ...
    # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    inputs.nixos-hardware.nixosModules.hp-elitebook-830g6
  ];
  #FIXME: breaks my insecurities
  # m.sec.enable = lib.mkForce false;

  m = {
    sw.steam.enable = true;
    hw.io.qmk.enable = true;
  };

  users.users.omega.openss.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOE1re70UdTTtM6Yv5uANJCThfxssJ3cc7wE8VlTST60 jovyan@jupyter-georgiy-shevoroshkin---8b1620bb" ];

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
