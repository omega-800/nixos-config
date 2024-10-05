{ config, lib, usr, sys, ... }:
# great resources
# https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/
# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
let
  inherit (lib) mkIf mkOption types;
  cfg = config.m.fs.disko.root.impermanence;
  # as you can see, code readability is my forté
  createAndLinkDirs = where: items:
    lib.mkMerge (map
      (item:
        let dir = "/${where}/${item}";
        in {
          "${dir}" =
            if where == "etc" then {
              d = {
                group = "root";
                mode = "0755";
                user = "root";
              };
              L.argument = "/persist${dir}";
            } else {
              source = "/persist${dir}";
            };
        })
      items);
in
{
  options.m.fs.disko.root.impermanence = {
    enable = mkOption {
      type = types.bool;
      default = sys.hardened && config.m.fs.disko.enable;
      description = "if fs should be impermanent";
    };
    persistVols = mkOption {
      type = types.listOf types.str;
      default = [ "home/${usr.username}" "var/log" "etc/nixos" ];
      description = "volumes which should persist after reboot";
    };
  };
  config = mkIf cfg.enable {
    disko.devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "defaults"
          "nodev"
          "nosuid"
          "noexec"
          "relatime"
          "size=2G"
          "mode=755"
        ];
      };
    };
    environment.etc = createAndLinkDirs "etc" [
      "adjtime"
      "NIXOS"
      "nixos"
      "machine-id"
      "ssh/authorized_keys.d"
      "ssh/ssh_host_rsa_key"
      "ssh/ssh_host_rsa_key.pub"
      "ssh/ssh_host_ed25519_key"
      "ssh/ssh_host_ed25519_key.pub"
      "NetworkManager/system-connections"
    ];
    #FIXME: fwupd, libvirt
    #TODO: move these into their respective config files
    systemd.tmpfiles = {
      settings."mk-var-lib-persist" = createAndLinkDirs "var/lib" [
        "bluetooth"
        "acme"
        "lxd"
        "docker"
        # if the above doesn't work
        # "NetworkManager/seen-bssids"
        # "NetworkManager/timestamps"
        # "NetworkManager/secret_key"
      ];

      # rules = [
      # Type Path Mode User Group Age Argument
      # "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
      # "L /var/lib/acme - - - - /persist/var/lib/acme"

      # if the above doesn't work
      #   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
      #   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
      #   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
      # ];
    };
    fileSystems = { "/var/log".neededForBoot = true; };
  };
}
