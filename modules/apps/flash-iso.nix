{ pkgs, ... }:
let
  name = "flash-iso";
  script =
    let
      pv = "${pkgs.pv}/bin/pv";
      fzf = "${pkgs.fzf}/bin/fzf";
      root = ../../.;
    in
    pkgs.writeShellScriptBin name # bash
      ''
        help() {
          cat <<EOF

        #############################################################################
          Flash NixOS as an iso to a usb drive

          Syntax: nix run .#flash-iso -[h|n (hostname)|d (device)]

          Options:
          h     print this help
          n     hostname (optional, fzf select if not provided)
          d     device to flash iso to (optional, fzf select if not provided) 
        #############################################################################

        EOF
        }

        set -euo pipefail

        hostname=""
        device=""

        while getopts ":hd:n:" arg; do
          case $arg in
          n) hostname="$OPTARG" ;;
          d) device="$OPTARG" ;;
          h | *) help && exit 0 ;;
          esac
        done

        # https://github.com/aldoborrero/templates/blob/main/templates/blog/nix/setting-up-machines-nix-style/nix/scripts.nix

        hosts="$(nix eval ${root}#nixosConfigurations --apply 'hosts: builtins.concatStringsSep " " (builtins.filter (n: (builtins.match ".*-iso" n) != null) (builtins.attrNames hosts))')"

        hosts=''${hosts#\"}
        hosts=''${hosts%\"}

        if [ -z "$hostname" ] || [ -z "''${hosts#*"$hostname"}" ]; then 
          host="$(echo "$hosts" | tr ' ' '\n' | ${fzf})"
        else 
          host="$hostname"
        fi

        # Build image
        nix build ${root}#nixosConfigurations.''${host}-iso.config.system.build.isoImage
        # Display fzf disk selector
        iso="./result/iso/"
        iso="$iso$(ls "$iso" | "${pv}")"
        if [ -n "$device" ] && [ -e "$device" ]; then
          dev="$device"
        else 
          dev="/dev/$(lsblk -d -n --output RM,NAME,FSTYPE,SIZE,LABEL,TYPE,VENDOR,UUID | awk '{ if ($1 == 1) { print } }' | "${fzf}" | awk '{print $2}')"
        fi

        # Format
        "${pv}" -tpreb "$iso" | sudo dd bs=4M of="$dev" iflag=fullblock conv=notrunc,noerror oflag=sync

        echo "done!"
      '';
in
{
  type = "app";
  program = "${script}/bin/${name}";
}
