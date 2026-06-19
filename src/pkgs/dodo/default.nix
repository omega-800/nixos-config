{
  notmuch, 
  offlineimap,
  python3,
  fetchFromGitHub,
  lib,
}:
let
  pname = "dodo";
  version = "1.0.0";
  owner = "akissinger";
  pp = python3.pkgs;
in
pp.buildPythonApplication {
  inherit pname version;

  pyproject = true;
  build-system = [ pp.setuptools ];

  propagatedBuildInputs =  [ notmuch offlineimap ] ++ (with pp; [ pyqt6 pyqt6-webengine bleach ]);

  src = fetchGit {
    url = "https://github.com/The-Compiler/dodo";
    rev = "722ee1632b40079791069beec87ab45f3894d4f1";
    ref = "fix-error-message-display";
    # sha256 = "sha256-IylZCG/7egGA7IBfSIMwmSbJVRv5cMWEtiIyds720Sw=";
  };
  # src = fetchFromGitHub {
  #   inherit owner;
  #   repo = pname;
  #   rev = "a710d0a3fe78d5bf4b3d07ea087712d3581e5a85";
  #   sha256 = "sha256-IylZCG/7egGA7IBfSIMwmSbJVRv5cMWEtiIyds720Sw=";
  # };

  meta = {
    homepage = "https://github.com/${owner}/${pname}";
    description = "A graphical, hackable email client based on notmuch";
    licenses = [ lib.licenses.gpl3 ];
    platforms = lib.platforms.unix;
    maintainers = [
      {
        github = "omega-800";
        githubId = 50942480;
        name = "omega";
      }
    ];
  };
}
