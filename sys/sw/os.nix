{ pkgs, userSettings, ... }: {
  nix = {
    nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    settings.allowed-users = [ "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.${userSettings.username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
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
