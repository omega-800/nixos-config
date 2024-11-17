let
  terminals = [
    { class = "kitty"; }
    { class = "alacritty"; }
    { class = "foot"; }
  ];
  browsers = [
    { class = "^Firefox$"; }
    { class = "chromium"; }
    { class = "Brave"; }
  ];
in
{
  work = {
    # TODO: check if classes are correct
    "1: social" = [
      { class = "Brave"; }
    ];
    "2: terminal" = terminals;
    "3: editor" = [
      { class = "vscode"; }
      { class = "eclipse"; }
    ];
    "4: web" = [
      { class = "^Firefox$"; }
      { class = "chromium"; }
    ];
    "5: rdm" = [ ];
    "6: remote" = [ ];
    "7: music" = [ ];
    "8: stuff" = [ ];
    "9: fuckups" = [ ];
    "0: extra" = [ ];
  };
  pers = {
    "1: local" = terminals;
    "2: devenv" = terminals;
    "3: web" = browsers;
    "4: web2" = browsers;
    "5: web3" = browsers;
    "6: remote" = [ ];
    "7: music" = [ ];
    "8: stuff" = [ ];
    "9: fuckups" = [ ];
    "0: extra" = [ ];
  };
}
