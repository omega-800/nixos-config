{
  inputs,
  lib,
  usr,
  sys,
  net,
  config,
  hostUsers,
  ...
}:
let
  cfg = config.m.os.users;
  inherit (lib)
    mkIf
    mkEnableOption
    optionals
    mkMerge
    mkForce
    ;
  inherit (lib.omega.def) mkDisableOption;
  inherit (lib.omega.cfg) mkSpecialisation;
  ifExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  primaryName = usr.username;
  primaryGroups = [ "wheel" "video" "audio" ] ++ ifExist [ "podman" "adbusers" ];
  mkUserEntry = u: {
    isNormalUser = true;
    home = u.user.usr.homeDir;
    shell = u.user.usr.shell;
    uid = lib.mkIf (u.user.uid != null) u.user.uid;
    hashedPasswordFile = config.sops.secrets."users/${u.user.usr.username}".path;
    extraGroups =
      if (u.user.usr.username == primaryName) then
        primaryGroups ++ u.user.extraGroups
      else
        u.user.extraGroups;
  };
  userEntries = lib.listToAttrs (map (u: lib.nameValuePair u.user.usr.username (mkUserEntry u)) hostUsers);
  primary = lib.head hostUsers;
  hmEntries =
    lib.listToAttrs (
      map (u: lib.nameValuePair u.user.usr.username { imports = u.homeModules; }) (
        lib.filter (u: u.user.usr.username == primaryName) hostUsers
      )
    );
  hmSharedArgs = primary.args;
  userSecrets = lib.listToAttrs (
    map (u: lib.nameValuePair "users/${u.user.usr.username}" { neededForUsers = true; }) hostUsers
  );
in
{
  imports = [ inputs.home-manager.nixosModules.default ];
  options.m.os.users = {
    # FIXME: implement without locking myself out
    mutable = mkEnableOption "mutable users";
    lockRoot = mkEnableOption "locks root user";
    enableHomeMgr = mkDisableOption "enables home-manager from nixos config";
  };
  config = mkMerge [
    (mkSpecialisation "school" {
      users = {
        extraGroups.wireshark = { };
        users.${primaryName}.extraGroups = [ "wireshark" ];
      };
    })
    {
      sops.secrets = {
        "users/root".neededForUsers = true;
      } // userSecrets;
      users = {
        users = {
          root = {
            # hashedPasswordFile = config.sops.secrets."users/root".path;
          };
        } // userEntries;
      };
      home-manager = mkIf cfg.enableHomeMgr {
        extraSpecialArgs = hmSharedArgs;
        users = hmEntries;
      };
    }
  ];
}
