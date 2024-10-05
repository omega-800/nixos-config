{ config, lib, usr, sys, inputs, ... }:
# great resources
# https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/
# https://grahamc.com/blog/erase-your-darlings/
# https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
# https://willbush.dev/blog/impermanent-nixos/
let
  inherit (lib) mkIf mkOption types;
  cfg = config.m.fs.disko.root.impermanence;
  # as you can see, code readability is my forté
  # but i decided to do it the js-developer way and "just use a library" 
  # instead of re-writing it in worse
  # createAndLinkDirs = where: items:
  #   lib.mkMerge (map
  #     (item:
  #       let dir = "/${where}/${item}";
  #       in {
  #         "${dir}" =
  #           if where == "etc" then {
  #             source = "/persist${dir}";
  #           } else {
  #             d = {
  #               group = "root";
  #               mode = "0755";
  #               user = "root";
  #             };
  #             L.argument = "/persist${dir}";
  #           };
  #       })
  #     items);
in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];
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
      # https://github.com/nix-community/impermanence?tab=readme-ov-file#tmpfs
      # All data stored in tmpfs only resides in system memory, not on disk. This automatically takes care of cleaning up between boots, but also comes with some pretty significant drawbacks:
      # Downloading big files or trying programs that generate large amounts of data can easily result in either an out-of-memory or disk-full scenario.
      # If the system crashes or loses power before you’ve had a chance to move files you want to keep to persistent storage, they’re gone forever.
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
    fileSystems = { "/var/log".neededForBoot = true; };
    environment.persistence."/nix/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        # {
        #   directory = "/var/lib/colord";
        #   user = "colord";
        #   group = "colord";
        #   mode = "u=rwx,g=rx,o=";
        # }
      ];
      files = [
        "/etc/machine-id"
        "/etc/NIXOS"
        "/etc/adjtime"
        # {
        #   file = "/var/keys/secret_file";
        #   parentDirectory = { mode = "u=rwx,g=,o="; };
        # }
      ];
    };
    # environment.etc = createAndLinkDirs "etc" [
    #   "adjtime"
    #   "NIXOS"
    #   "nixos"
    #   "machine-id"
    #   "ssh/authorized_keys.d"
    #   "ssh/ssh_host_rsa_key"
    #   "ssh/ssh_host_rsa_key.pub"
    #   "ssh/ssh_host_ed25519_key"
    #   "ssh/ssh_host_ed25519_key.pub"
    #   "NetworkManager/system-connections"
    # ];
    #FIXME: fwupd, libvirt
    #TODO: move these into their respective config files
    # systemd.tmpfiles = {
    #   settings."mk-var-lib-persist" = createAndLinkDirs "var/lib" [
    #     "bluetooth"
    #     "acme"
    #     "lxd"
    #     "docker"
    #     # if the above doesn't work
    #     # "NetworkManager/seen-bssids"
    #     # "NetworkManager/timestamps"
    #     # "NetworkManager/secret_key"
    #   ];

    # rules = [
    # Type Path Mode User Group Age Argument
    # "L /var/lib/bluetooth - - - - /persist/var/lib/bluetooth"
    # "L /var/lib/acme - - - - /persist/var/lib/acme"

    # if the above doesn't work
    #   "L /var/lib/NetworkManager/secret_key - - - - /persist/var/lib/NetworkManager/secret_key"
    #   "L /var/lib/NetworkManager/seen-bssids - - - - /persist/var/lib/NetworkManager/seen-bssids"
    #   "L /var/lib/NetworkManager/timestamps - - - - /persist/var/lib/NetworkManager/timestamps"
    # ];
    # };
  };
}
