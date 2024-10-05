{ lib, config, pkgs, usr, sys, ... }:
with lib;
let cfg = config.m.dev.virt;
in {
  options.m.dev.virt.enable = mkOption {
    description = "enables virtualization";
    type = types.bool;
    default = config.m.dev.enable
      && (builtins.any (f: builtins.elem f [ "parent" "developer" ])
      sys.flavors);
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      mkIf (usr.extraBloat) (with pkgs; [ distrobox ]);
    programs.virt-manager.enable = true;
    users.users.${usr.username}.extraGroups = [ "libvirt" "libvirtd" "kvm" ];
    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [ "nm-bridge" "virbr0" ];
      qemu.runAsRoot = !sys.hardened;
    };
  };
}
