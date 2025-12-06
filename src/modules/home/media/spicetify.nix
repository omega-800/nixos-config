{
  lib,
  config,
  pkgs,
  inputs,
  usr,
  ...
}:
let
  inherit (lib) mkIf types mkOption;
  cfg = config.u.media.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  customColorScheme = with config.lib.stylix.colors; {
    text = base07;
    main = base00;
    player = base01;
    card = base02;
    shadow = base03;
    sidebar = base0C;
    sidebar-text = base00;
    subtext = base06;
    selected-row = base04;
    button = base0C;
    button-active = base0C;
    button-disabled = base05;
    tab-active = base0D;
    notification = base0F;
    notification-error = base08;
    misc = base0E;
  };
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.u.media.spicetify.enable = mkOption {
    type = types.bool;
    default = config.u.media.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      # theme = spicePkgs.themes.dribbblish;
      # specify that we want to use our custom colorscheme
      # colorScheme = "custom";
      # inherit customColorScheme;

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        #lyricsPlus
        #reddit
        historyInSidebar
        #ncsVisualizer
      ];

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle
        trashbin
        loopyLoop
        #popupLyrics
        keyboardShortcut
        # Community Extensions
        adblock
        powerBar
        groupSession
        #wikify
        #songStats
        playNext
        beautifulLyrics
      ];
    };
  };
}
