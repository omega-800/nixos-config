{ pkgs, ... }:
let
  name = "remote-build";
  script = pkgs.writeShellScriptBin name ''
    config_path="$''${WORKSPACE_DIR:-HOME/ws}/nixos-config"
    hosts=($(nix eval $config_path#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.attrNames pkgs)' | xargs))
    for host in $hosts; do 
      #nixos-rebuild switch --flake $config_path#$host --show-trace --use-remote-sudo --target-host omega@10.0.0.49
      echo $host
    done
  '';
in {
  type = "app";
  program = "${script}/bin/${name}";
}
