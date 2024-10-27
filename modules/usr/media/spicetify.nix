pkgs: curtheme: spicetify-nix:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};

  customColorScheme = with curtheme; {
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
}
