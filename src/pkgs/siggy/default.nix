{
  lib,
  rustPlatform,
  fetchFromGitHub,
  signal-cli,
}:
let
  pname = "siggy";
  version = "1.15.0";
  src = fetchFromGitHub {
    owner = "johnsideserf";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-A4MP5KueSASifhN4q1S6wkIi2ceJFwX8wJjnxiSiMk4=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  buildInputs = [
    signal-cli
  ];

  cargoHash = "sha256-nQVrVQ7EfcFoRwfa939z5Uhk3221Vq9kD+MCCBQINSY=";

  meta = with lib; {
    description = "Terminal-based Signal messenger client with vim keybindings";
    homepage = "https://github.com/${src.owner}/${pname}";
    changelog = "https://github.com/${src.owner}/${pname}/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = [
      {
        github = "omega-800";
        githubId = 50942480;
        name = "omega";
      }
    ];
  };
}
