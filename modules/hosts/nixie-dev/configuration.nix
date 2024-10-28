{ config, lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m.os.boot.mode = "bios";
  m.dev.virt.enable = false;
  m.dev.tools = {
    enable = lib.mkForce true;
    disable = lib.mkForce false;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" "armv7l-linux" ];
  # boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  system.stateVersion = "24.05";
}
