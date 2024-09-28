{ pkgs, ... }:
let
  script = pkgs.writeShellScriptBin "init-nix" (builtins.readFile ./script.sh);
in {
  type = "app";
  program = "${script}/bin/init-nix";
}
