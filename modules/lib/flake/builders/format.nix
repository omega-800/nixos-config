{ inputs }: {
  mapFormatterByArch = system:
    inputs.nixpkgs-unstable.legacyPackages.${system}.nixfmt-rfc-style;
}
