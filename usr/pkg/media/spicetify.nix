pkgs: curtheme: spicetify-nix:
let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  #TODO: make this better
  theme =
    if pkgs.lib.strings.hasPrefix "gruvbox" curtheme then
      spicePkgs.themes.Dribbblish
    else
      spicePkgs.themes.catppuccin;
  colorScheme =
    if pkgs.lib.strings.hasPrefix "gruvbox" curtheme then
      "gruvbox"
    else
      "mocha";

in
{
  enable = true;
  #theme = spicePkgs.themes.catppuccin;
  #colorScheme = "mocha";
  inherit theme colorScheme;

  enabledCustomApps = with spicePkgs.apps; [ new-releases lyrics-plus reddit ];

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
