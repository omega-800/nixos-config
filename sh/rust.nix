{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [ cargo-deny cargo-edit cargo-watch rust-analyzer ];
  buildInputs = with pkgs; [ openssl.dev ];
  nativeBuildInputs = with pkgs; [ rustc cargo pkg-config nixpkgs-fmt ];
  env = {
    # Required by rust-analyzer
    RUST_SRC_PATH =
      "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}/lib/rustlib/src/rust/library";
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
