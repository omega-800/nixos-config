{ pkgs, lib, nixvim, ... }:
let
  cfg = lib.evalModules {
    modules = [
      ../profiles/default/options.nix
      {
        u.user.nixvim = {
          enable = true;
          langSupport = [ "rust" "md" "sh" "nix" ];
        };
      }
    ];
  };
in pkgs.mkShell {
  packages = with pkgs; [
    cargo-deny
    cargo-edit
    cargo-watch
    rust-analyzer
    (nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvim ({
      config.colorschemes.gruvbox.enable = true;
    } // (import ../usr/pkg/user/nixvim {
      inherit lib pkgs;
      inherit (cfg.c) sys usr config;
    })))
  ];
  buildInputs = with pkgs; [ openssl.dev ];
  nativeBuildInputs = with pkgs; [ rustc cargo pkg-config nixpkgs-fmt ];
  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH =
      "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}/lib/rustlib/src/rust/library";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
