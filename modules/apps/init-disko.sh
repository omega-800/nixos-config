#!/bin/sh

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake github:omega-800/nixos-config#$1
