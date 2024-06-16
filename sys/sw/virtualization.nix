{ config, pkgs, usr, ... }:

{
  environment.systemPackages = with pkgs; [ distrobox ];
  programs.virt-manager.enable = true;
  users.users.${usr.username}.extraGroups = [ "ibvirtd" ];
  virtualisation.libvirtd = {
    allowedBridges = [
      "nm-bridge"
      "virbr0"
    ];
    enable = true;
    qemu.runAsRoot = false;
  };
}
