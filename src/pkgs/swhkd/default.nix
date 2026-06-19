# https://github.com/danielphan2003/fog/blob/main/src/all-packages/generated.nix
# https://github.com/danielphan2003/flk/blob/198bf56b8dde0c075f89f58952bedfa85e0b3cf7/cells/flk/packages/applications/window-managers/swhkd/default.nix
# { rustPlatform, fetchFromGitHub }:
# rustPlatform.buildRustPackage {
#   pname = "swhkd";
#   version = "3b19fc33b32efde88311579152a1078a8004397c";
#
#   src = fetchFromGitHub {
#     owner = "waycrate";
#     repo = "swhkd";
#     rev = "3b19fc33b32efde88311579152a1078a8004397c";
#     fetchSubmodules = false;
#     sha256 = "sha256-245Y3UicW33hrQ6Mtf07I9vsWSpuijIEoEhxIKtjVQE=";
#   };
#
#   cargoLock = {
#     lockFile = ./Cargo.lock;
#     outputHashes = { };
#   };
#
#   preInstall = ''
#     mkdir -p $out/lib/systemd/user $out/share/polkit-1/actions
#
#     substitute ./contrib/init/systemd/hotkeys.service "$out/lib/systemd/user/swhkd.service" \
#       --replace '# ExecStart=/path/to/hotkeys.sh' "ExecStart=/run/wrappers/bin/pkexec $out/bin/swhkd"
#
#     substitute ./com.github.swhkd.pkexec.policy "$out/share/polkit-1/actions/com.github.swhkd.pkexec.policy" \
#       --replace /usr/bin/swhkd "$out/bin/swhkd"
#   '';
# }

# https://github.com/NixOS/nixpkgs/pull/306159/files
{ lib
, rustPlatform
, fetchurl
, fetchFromGitHub
, pkg-config
, scdoc
, libgcc
, systemd
}:
rustPlatform.buildRustPackage rec {
    pname = "swhkd";
    version = "1.2.1-unstable-2024-04-06";

    # split-output derivation, since there's a fair amount of associated data for
    # pkexec and such.
    outputs = [ "bin" "man" "out" ];

    src = fetchFromGitHub {
      owner = "waycrate";
      repo = "swhkd";
      # build from master, since the 1.2.1 makefile is unsutible for packaging
      rev = "f8519a54900d72492a6c036b32e472c108d44dbf";
      hash = "sha256-zyGyZOG8gAtsRkzSRH1M777fPv1wudbVsBrSTJ5CBnY=";
    };

    nativeBuildInputs = [
      scdoc
      pkg-config
    ];

    # the makefile tries to set the ownership of a file to root.
    # this will fail, but files are owned by root anyways.
    postPatch = ''
      sed -ie 's/-o root//' Makefile
    '';

    buildPhase = ''
      runHook preBuild
      make build
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out $bin $man/share
      make DESTDIR=$out MAN1_DIR=/share/man/man1 MAN5_DIR=/share/man/man5 TARGET_DIR=/bin install
      mv $out/bin $bin/bin
      mv $out/share/man $man/share/man
      mv $out/usr/share/polkit-1 $out/share/polkit-1
      rm -r $out/etc $out/usr

      runHook postInstall
    '';

    cargoHash = "sha256-pqw28dnGCa1ptlPoQKOgjoCWnUvdcqrwz7NGEYLVXqk=";

    buildInputs = [
      systemd
      libgcc
    ];

    meta = with lib; {
      description = "A drop-in replacement for sxhkd that works with wayland";
      homepage = "https://github.com/waycrate/swhkd";
      changelog = "https://github.com/waycrate/swhkd/blob/${src.rev}/CHANGELOG.md";
      license = licenses.bsd2;
      maintainers = with maintainers; [ binarycat ];
    };
  }
