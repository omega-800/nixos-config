{
  inputs,
  lib,
  usr,
  sys,
  net,
  config,
  CONFIGS,
  PATHS,
  ...
}:
let
  cfg = config.m.os.users;
  inherit (lib) mkIf mkEnableOption optionals;
  inherit (lib.omega.def) mkDisableOption;
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
# inherit (import (PATHS.LIBS + /flake/utils/util.nix) { inherit inputs; }) mkModules;
{
  imports = [ inputs.home-manager.nixosModules.default ];
  options.m.os.users = {
    # FIXME: implement without locking myself out 
    mutable = mkEnableOption "mutable users";
    lockRoot = mkEnableOption "locks root user";
    enableHomeMgr = mkDisableOption "enables home-manager from nixos config";
  };
  config = {
    #TODO: split sops secrets per-user
    sops.secrets = {
      "users/root".neededForUsers = true;
      "users/${usr.username}".neededForUsers = true;
    };
    users = {
      #FIXME: fml broke my pc again
      # mutableUsers = cfg.mutable;
      users = {
        #FIXME: i fucked uuuup
        root = {
          # hashedPasswordFile = config.sops.secrets."users/root".path;
          # to lock root account
          # hashedPasswordFile = "!";
        };
        ${usr.username} = {
          isNormalUser = true;
          #FIXME: why doesn't this work??
          # i'm confused, past omega. it works on my machine?
          hashedPasswordFile = config.sops.secrets."users/${usr.username}".path;
          packages = optionals cfg.enableHomeMgr [ inputs.home-manager.packages.${sys.system}.home-manager ];
          extraGroups =
            [
              "wheel"
              "video"
              "audio"
            ]
            ++ ifExist [
              "podman"
              "adbusers"
            ];
        };
      };
    };
    home-manager = mkIf cfg.enableHomeMgr {
      # FIXME: ideally this would be done with 
      # mkModules { inherit usr sys; } CONFIGS.homeConfigurations;
      # yields infinite recursion
      # users.${usr.username} = {
      #   imports = [
      #     (PATHS.PROFILES + /default/${CONFIGS.homeConfigurations}.nix)
      #     (PATHS.PROFILES + /${sys.profile}/${CONFIGS.homeConfigurations}.nix)
      #     (PATHS.NODES + /${net.hostname}/${CONFIGS.homeConfigurations}.nix)
      #   ];
      # };
    };
  };
}
