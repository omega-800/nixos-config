{ pkgs, usr, sys, globals, lib, config, ... }: {
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
      if usr.extraBloat then [ "devdoc" "dev" "info" ] else [ ];
    sessionVariables = globals.envVars;
  };

  networking = { };

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    trustedPublicKeys =
      lib.flatten (lib.my.cfg.getCfgAttrOfAllHosts "sys" "pubkeys");
  };

  /* home-manager = {
       backupFileExtension = ".bak-hm";
       useGlobalPackages = true;
       useUserPackages = false;
       config = ../usr;
     };
  */

  time.timeZone = sys.timezone;
  terminal = {
    inherit (sys) font;
    colors = let
      theme = lib.my.templ.fromYAML ../themes/${usr.theme}/${usr.theme}.yaml;
    in (lib.my.attrs.filterMapAttrNames
      (n: v: !builtins.elem n [ "scheme" "author" ]) (n:
        "color" +
        # remove leading zeros
        builtins.toString (lib.fromHexString (builtins.substring 4 6 n))) theme)
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
    userName = lib.mkForce usr.username;
  };
  system.stateVersion = "24.05";
}
