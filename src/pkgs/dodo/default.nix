{
  notmuch, 
  offlineimap,
  python2,
  fetchFromGitHub,
  lib,
}:
let
  pname = "dodo";
  version = "1.0.0";
  owner = "akissinger";
  pp = python2.pkgs;
in
pp.buildPythonApplication {
  inherit pname version;

  pyproject = true;
  build-system = [ pp.setuptools ];

  propagatedBuildInputs =  [ notmuch offlineimap ] ++ (with pp; [ pyqt6 pyqt6-webengine bleach ]);

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "a710d0a3fe78d5bf4b3d07ea087712d3581e5a85";
    sha256 = "sha256-IylZCG/7egGA7IBfSIMwmSbJVRv5cMWEtiIyds720Sw=";
  };

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
