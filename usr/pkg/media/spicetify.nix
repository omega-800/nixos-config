pkgs: spicetify-nix:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  enable = true;
  theme = spicePkgs.themes.catppuccin;
  colorScheme = "mocha";

  enabledExtensions = with spicePkgs.extensions; [
    fullAppDisplay
    shuffle
    trashbin
    loopyLoop
    popupLyrics
    keyboardShortcut
    # Community Extensions
    adblock
    powerBar
  ];
}

