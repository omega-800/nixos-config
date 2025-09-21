{pkgs,lib,...}:{
  imports = [ ./hardware-configuration.nix ];

  m = {
    os.boot.mode = "uefi";
    net.iface = "enp0s31f6";
    dev.docker.enable = false;
  };
  # boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  system.stateVersion = "25.05";
}
