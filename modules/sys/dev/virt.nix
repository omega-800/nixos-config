{
  lib,
  config,
  pkgs,
  usr,
  sys,
  ...
}:
let
  cfg = config.m.dev.virt;
  inherit (lib) mkEnableOption mkIf;
in
{
  options.m.dev.virt = {
    enable = mkEnableOption "enables virtualization";
    distrobox.enable = mkEnableOption "enables distrobox";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = mkIf (cfg.distrobox.enable) (with pkgs; [ distrobox ]);

      persistence = lib.mkIf config.m.fs.disko.root.impermanence.enable {
        "/nix/persist".directories = [
          "/etc/NetworkManager/system-connections"
          "/var/lib/NetworkManager/seen-bssids"
          "/var/lib/NetworkManager/timestamps"
          "/var/lib/NetworkManager/secret_key"
        ];
      };
    };

    programs.virt-manager.enable = true;
    users.users.${usr.username}.extraGroups = [
      "libvirt"
      "libvirtd"
      "kvm"
    ];
    virtualisation.libvirtd = {
      enable = true;
      allowedBridges = [
        "nm-bridge"
        "virbr0"
      ];
      qemu.runAsRoot = !sys.hardened;
    };
  };
}
