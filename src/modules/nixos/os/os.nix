{
  config,
  pkgs,
  usr,
  sys,
  lib,
  inputs,
  ...
}:
let
  # package = pkgs.nixFlakes;
  # for better error msgs
  # https://lix.systems/
  package = pkgs.lix;
in
{
  #system-manager.allowAnyDistro = sys.genericLinux;
  environment = {
    defaultPackages = [ ];
    systemPackages =
      let
        repl-fast = pkgs.writeShellScriptBin "repl-fast" ''
          source /etc/set-environment
          nix repl "${toString ./repl.nix}" "$@"
        '';
      in
      [
        repl-fast
        pkgs.vim
        pkgs.curl
        pkgs.gitMinimal
      ];
  };

  services = lib.mkIf (!sys.stable) { gnome.gnome-keyring.enable = true; };
  nix = {
    inherit package;
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
        to = {
          inherit (pkgs) path;
          type = "path";
          narHash = builtins.readFile (
            pkgs.runCommandLocal "get-nixpkgs-hash" {
              nativeBuildInputs = [ pkgs.nix ];
            } "nix-hash --type sha256 --sri ${pkgs.path} > $out"
          );
        };
      };
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      # "repl=${toString ./.}/repl.nix"
      # "/nix/var/nix/profiles/per-user/root/channels"
    ];
    #extraOptions = "experimental-features = nix-command flakes";
    settings = {
      extra-platforms = config.boot.binfmt.emulatedSystems;
      sandbox = sys.paranoid;
      auto-optimise-store = true; # Optimize syslinks
      trusted-users = [
        "root"
        "@wheel"
        usr.username
      ];
      allowed-users = [ "@wheel" ];
      experimental-features =
        [
          "nix-command"
          "flakes"
        ]
        ++ lib.optional (lib.versionOlder (lib.versions.majorMinor config.nix.package.version) "2.22") "repl-flake";
      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;
      # Fallback quickly if substituters are not available.
      connect-timeout = 5;
      # The default at 10 is rarely enough.
      log-lines = 25;
      # Avoid disk full issues
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    daemonCPUSchedPolicy = lib.mkDefault "batch";
    daemonIOSchedClass = lib.mkDefault "idle";
    daemonIOSchedPriority = lib.mkDefault 7;

    # Disable nix channels. Use flakes instead.
    channel.enable = sys.profile != "serv";
    optimise.automatic = true;
    # De-duplicate store paths using hardlinks except in containers
    # where the store is host-managed.
    # optimise.automatic = (!sys.isContainer);
  };

  systemd.services = {
    # Make builds to be more likely killed than important services.
    # 100 is the default for user slices and 500 is systemd-coredumpd@
    # We rather want a build to be killed than our precious user sessions as builds can be easily restarted.
    nix-daemon.serviceConfig.OOMScoreAdjust = 250;
    # default is something like vt220... however we want to get alt least some colors...
    "serial-getty@".environment.TERM = "xterm-256color";
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
