{
  pkgs,
  usr,
  sys,
  globals,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    flatten
    omega
    fromHexString
    mkForce
    ;
in
{
  android-integration = {
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    # i need my precious mAh
    termux-wake-unlock.enable = false;
    termux-wake-lock.enable = false;
    # maybe someday
    #termux-unsupported.enable = false;

    xdg-open.enable = true;
  };
  # handled by hm
  # build.activation = { };
  environment = {
    # binSh = lib.mkForce "${usr.shell}";
    etcBackupExtension = ".bak";
    extraOutputsToInstall =
      if usr.extraBloat then
        [
          "devdoc"
          "dev"
          "info"
        ]
      else
        [ ];
    sessionVariables = globals.envVars;
  };

  networking = { };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    trustedPublicKeys = flatten (omega.cfg.getCfgAttrOfAllHosts "net" "pubkeys");
  };

  /*
    home-manager = {
      backupFileExtension = ".bak-hm";
      useGlobalPackages = true;
      useUserPackages = false;
      config = ../usr;
    };
  */

  time.timeZone = sys.timezone;
  terminal = {
    inherit (sys) font;
    colors =
      let
        theme = omega.templ.fromYAML ../themes/${usr.theme}/${usr.theme}.yaml;
      in
      (omega.attrs.filterMapAttrNames
        (
          n: v:
          !builtins.elem n [
            "scheme"
            "author"
          ]
        )
        (
          n:
          "color"
          +
            # remove leading zeros
            builtins.toString (fromHexString (builtins.substring 4 6 n))
        )
        theme
      )
      // {
        # https://github.com/danth/stylix/blob/master/modules/alacritty/hm.nix
        background = theme.base00;
        foreground = theme.base05;
        cursor = theme.base05;
      };
  };
  user = {
    inherit (usr) shell;
    home = usr.homeDir;
    userName = mkForce usr.username;
  };
  system.stateVersion = "24.05";
}
