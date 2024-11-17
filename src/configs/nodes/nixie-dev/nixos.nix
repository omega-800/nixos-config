{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  m = {
    dev = {
      virt.enable = false;
      tools = {
        enable = lib.mkForce true;
        disable = lib.mkForce false;
      };
      docker.enable = true;
      mysql.enable = false;
    };
    fs.disko = {
      enable = true;
      root = {
        device = "/dev/sda";
        impermanence.enable = false;
        encrypt = false;
      };
    };
    hw.power.enable = false;
    os = {
      boot.mode = "bios";
      users.enableHomeMgr = true;
    };
    net.vpn.wg.enable = false;
  };
  boot = {
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "i686-linux"
      "armv7l-linux"
    ];
    kernelModules = [
      "kvm-amd"
      "kvm-intel"
    ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  };
  system.stateVersion = "24.05";
}
