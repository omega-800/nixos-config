{ config, pkgs, usr, ... }: 
let
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  nix = {
    nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];
    package = pkgs.nixFlakes;
    #extraOptions = "experimental-features = nix-command flakes";
    settings = {
      auto-optimise-store = true; # Optimize syslinks
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "@wheel" ];
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfree = true;

  users.users.${usr.username} = {
    isNormalUser = true;
    initialPassword = "password"; # TODO: Encrypt password
    extraGroups = [ "wheel" "video" "audio" ] ++ ifExist [
      "kvm"
      "docker"
      "podman"
      "adbusers"
      "libvirtd"
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
}
