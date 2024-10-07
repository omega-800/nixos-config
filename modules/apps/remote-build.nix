{ pkgs, ... }:
let
  name = "remote-build";
  script =
    let fzf = "${pkgs.fzf}/bin/fzf";
    in pkgs.writeShellScriptBin name ''
      help() {
        cat <<EOF

      #############################################################################
        Deploy NixOS config to a remote host

        Syntax: nix run .#remote-deploy -[h|n (hostname)]

        Options:
        h     print this help
        n     hostname (deploys all if not provided)
      #############################################################################

      EOF
      }

      set -euo pipefail

      hostname=""
      #TODO: implement multiple and builders
      single="true"

      while getopts ":hn:" arg; do
        case $arg in
        n) hostname="$OPTARG" ;;
        h | *) help && exit 0 ;;
        esac
      done

      config_path="''${WORKSPACE_DIR:-HOME/ws}/nixos-config"
      hosts=($(nix eval $config_path#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.filter (n: (builtins.match ".*-iso" n) == null) (builtins.attrNames pkgs))' | xargs))

      if [ -z "$hostname" ] || [ -z "''${hosts#*"$hostname"}" ]; then 
        [ -n "$single" ] && singlehost="$(echo "$hosts" | tr ' ' '\n' | ${fzf})"
      else 
        singlehost="$hostname"
      fi

      deploy() {
        ip="$(nix eval .#nixosConfigurations.$1.config.networking.interfaces --apply 'ifaces: with builtins; (elemAt ifaces.''${elemAt (attrNames ifaces) 0}.ipv4.addresses 0).address' | xargs)"
        uname="omega"
        nixos-rebuild switch --flake $config_path#$1 --show-trace --use-remote-sudo --target-host $uname@$ip
      }

      if [ -z "$singlehost" ]; then
        for host in ''${hosts[@]}; do 
          deploy "$host"
        done
      else 
        deploy "$singlehost"
      fi
    '';
in
{
  type = "app";
  program = "${script}/bin/${name}";
}
