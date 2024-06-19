{ lib, config, pkgs, usr, ... }: 
with lib;
let cfg = config.m.virt;
in {
  options.m.virt = {
    enable = mkEnableOption "enables virtualization";
  };

  config = mkIf cfg.enable {
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
  };
}
