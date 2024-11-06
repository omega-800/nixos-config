# https://github.com/danielphan2003/fog/blob/main/src/all-packages/generated.nix
# https://github.com/danielphan2003/flk/blob/198bf56b8dde0c075f89f58952bedfa85e0b3cf7/cells/flk/packages/applications/window-managers/swhkd/default.nix
{ rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage {
  pname = "swhkd";
  version = "3b19fc33b32efde88311579152a1078a8004397c";

  src = fetchFromGitHub {
    owner = "waycrate";
    repo = "swhkd";
    rev = "3b19fc33b32efde88311579152a1078a8004397c";
    fetchSubmodules = false;
    sha256 = "sha256-245Y3UicW33hrQ6Mtf07I9vsWSpuijIEoEhxIKtjVQE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = { };
  };

  preInstall = ''
    mkdir -p $out/lib/systemd/user $out/share/polkit-1/actions

    substitute ./contrib/init/systemd/hotkeys.service "$out/lib/systemd/user/swhkd.service" \
      --replace '# ExecStart=/path/to/hotkeys.sh' "ExecStart=/run/wrappers/bin/pkexec $out/bin/swhkd"

    substitute ./com.github.swhkd.pkexec.policy "$out/share/polkit-1/actions/com.github.swhkd.pkexec.policy" \
      --replace /usr/bin/swhkd "$out/bin/swhkd"
  '';
}
