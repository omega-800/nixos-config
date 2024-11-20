#!/usr/bin/env bash

help() {
  cat <<EOF

#############################################################################
  NixOS setup through nixos-anywhere

  Syntax: nix run .#nixos-anywhere -[h|n (hostname)|d (destination)]

  Options:
  h     print this help
  n     hostname of the new machine as in nixosConfigurations.\${host}
  d     ip or fqdn of the new machine to ssh into
#############################################################################

EOF
}

while getopts ":hn:d:" arg; do
  case $arg in
  n) hostname="$OPTARG" ;;
  d) destination="$OPTARG" ;;
  h | *) help && exit 0 ;;
  esac
done

[ "$hostname" = "" ] && echo "please provide a hostname with -n" && exit 1
[ "$destination" = "" ] && echo "please provide a destination with -d" && exit 1

# https://github.com/nix-community/nixos-anywhere/blob/main/docs/howtos/secrets.md
temp=$(mktemp -d)
tempdisk=$(mktemp -d)
cleanup() {
  rm -rf "$temp"
  rm -rf "$tempdisk"
}
trap cleanup EXIT
install -d -m755 "$temp/etc/ssh"
pass home-net/nixie-ssh-key >"$temp/etc/ssh/ssh_host_ed25519_key"
chmod 600 "$temp/etc/ssh/ssh_host_ed25519_key"
keysd="$HOME/.config/sops/age"
keystxt="$keysd/keys.txt"
mkdir -p "${temp}${keysd}"
cp "$keystxt" "${temp}${keystxt}"
# TODO: enumerate disks and evaluate their keys from nixos config
# read from pass or create under /disk/${hostname}

# pass home-net/disk/default >"$tempdisk/root.key"
nixos-anywhere \
  --extra-files "$temp" \
  -f ".#$hostname" "root@$destination"
# --disk-encryption-keys /tmp/root.key "$tempdisk/root.key" \
