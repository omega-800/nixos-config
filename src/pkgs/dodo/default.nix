{
  python3,
  fetchFromGitHub,
  lib,
}:
let
  pname = "dodo";
  version = "1.0.0";
  owner = "akissinger";
in
python3.pkgs.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    inherit owner;
    repo = pname;
    rev = "a710d0a3fe78d5bf4b3d07ea087712d3581e5a85";
    fetchSubmodules = false;
    sha256 = "sha256-gk/9PVIRw9OQrdCSS+LcniXDYNcHUQUxZ2XGQCwpHaI=";
  };

  meta = {
    homepage = "https://github.com/${owner}/${pname}";
    description = "A graphical, hackable email client based on notmuch";
    licenses = with lib.licenses; [
      gpl3
    ];
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
