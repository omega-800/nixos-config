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
  inherit (builtins) elem;
  inherit (lib) mkForce mkMerge;
  inherit (lib.omega.cfg) mkSpecialisation;
in
{
  config = mkMerge [
    (mkSpecialisation "serv" {
      nix = {
        # Disable nix channels. Use flakes instead.
        channel.enable = false;
        gc = {
          dates = mkForce "weekly";
          options = mkForce "--delete-older-than 7d";
        };
      };
    })
    {
      #system-manager.allowAnyDistro = sys.genericLinux;
      environment = {
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
        # TODO: registry = (mapAttrs (_: flake: { inherit flake; }) flakeInputs) // {
        # https://github.com/NixOS/nixpkgs/pull/388090
        #   nixpkgs = lib.mkForce { flake = inputs.nixpkgs; };
        # };
        registry.nixpkgs = {
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
        nixPath = [
          "nixpkgs=${inputs.nixpkgs}"
          # "repl=${toString ./.}/repl.nix"
          # "/nix/var/nix/profiles/per-user/root/channels"
        ];
        #extraOptions = "experimental-features = nix-command flakes";
        settings = {
          keep-outputs = elem "developer" sys.flavors; # Nice for developers
          keep-derivations = elem "developer" sys.flavors; # Idem
          substitute = "true";
          extra-substituters = [
            "https://cache.nixos.org"
            "https://crane.cachix.org"
            "https://isabelroses.cachix.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-wayland.cachix.org"
            "https://viperml.cachix.org"
            "https://cache.lix.systems"
            "https://microvm.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
            "isabelroses.cachix.org-1:mXdV/CMcPDaiTmkQ7/4+MzChpOe6Cb97njKmBQQmLPM="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
            "viperml.cachix.org-1:qZhKBMTfmcLL+OG6fj/hzsMEedgKvZVFRRAhq7j8Vh8="
            "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
            "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
          ];
          cores = 0;
          # max-jobs = 2;
          max-jobs = "auto";

          extra-experimental-features = [
            "nix-command"
            "flakes"
          ];
          #bash-prompt = "> ";
          # system-features = "kvm";
          use-xdg-base-directories = true;
          extra-platforms = config.boot.binfmt.emulatedSystems;
          # TODO: check if lon causes any problems
          # sandbox = sys.paranoid;
          experimental-features = [
            "nix-command"
            "flakes"
          ]
          ++ lib.optional (lib.versionOlder (lib.versions.majorMinor config.nix.package.version) "2.22") "repl-flake";

          # FIXME: lon
          trusted-users = lib.mkForce [
            "root"
            "@wheel"
            usr.username
          ];
        };
        daemonCPUSchedPolicy = lib.mkDefault "batch";
        daemonIOSchedClass = lib.mkDefault "idle";
        daemonIOSchedPriority = lib.mkDefault 7;

        # De-duplicate store paths using hardlinks except in containers
        # where the store is host-managed.
        # optimise.automatic = (!sys.isContainer);
      };

      # default is something like vt220... however we want to get alt least some colors...
      systemd.services."serial-getty@".environment.TERM = "xterm-256color";

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;
    }
  ];
}
