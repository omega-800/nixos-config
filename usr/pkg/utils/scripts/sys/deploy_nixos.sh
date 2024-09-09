#!/usr/bin/env bash

hostname=$1
hosts=($(echo `nix eval .#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.attrNames pkgs)'` | xargs ))

if [[ "$hostname" = $(hostname) ]]; then
  echo "use nrs to build this host"
  exit 1
elif [[ " ${hosts[*]} " =~ " ${hostname} " ]]; then
  # nix build -L .#nixosConfigurations.remotehost.config.system.build.toplevel
  # nix copy --to ssh-ng://root@remotehost ./result
  # ssh root@remotehost nix-env -p /nix/var/nix/profiles/system --set $(readlink ./result)
  # ssh root@remotehost /nix/var/nix/profiles/system/bin/switch-to-configuration switch
  nixos-rebuild switch --use-remote-sudo --build-host localhost --target-host $hostname.home.lan --flake ".#$hostname"
else
  echo -e "no host with name $hostname found.\navailable are: ${hosts[@]}"
  exit 1
fi





nixpath=$(nix build .#nixosConfigurations.$hostname.config.system.build.toplevel --print-out-paths)
nix copy $nixpath --to ssh://root@$hostname.home.lan
