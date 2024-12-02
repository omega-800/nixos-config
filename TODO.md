# TODO

https://github.com/ibizaman/selfhostblocks
https://github.com/cynicsketch/nix-mineral
https://discourse.nixos.org/t/error-building-a-raspberry-pi-image-using-nix-on-a-x86-64-system/37968/2
https://jade.fyi/blog/flakes-arent-real
https://github.com/nix-community/srvos/blob/main/README.md
https://github.com/astro/microvm.nix/blob/main/doc/src/intro.md
https://github.com/ip1981/nixsap
https://github.com/xtruder/nix-profiles
https://github.com/nixcloud/nixcloud-webservices

## home-manager

- nvim
  - none-ls go plugin writes garbage .null-ls\* files
  - md plugin is too aggressive
  - put whole nixvim config in separate flake

## nixos

- nix sops
- [vault](https://github.com/serokell/vault-secrets)

## general

- added lots of half-baked modules, gotta sort em out and implement them precisely
- fs / disko
- testing
  - disko
  - iso
  - deploy-rs
  - profiles
- wayland setup
- stylix generalization (hm & os)
- devshells
- nixify scripts
- ~touch grass~
- **modularize profiles**
  - gui
  - sec
  - def
  - serv
  - work
  - pers
- include \*, handle "imports" / modules through \*.enable = true;
- refactor lib/my
- remove all with;'s

- paranoia
  - network
    - ipv{4,6}
    - ssh{,d}
    - kerberos
    - fail2ban
    - time
    - dns
    - firewall
    - mac
  - sw
    - gpg
    - apparmor
    - sops
    - doas
    - firejail
    - antivirus
    - systemd
    - wrappers
    - isolate
    - pam
    - virt
  - fs
    - permissions
    - usbguard
    - impermanence
  - os
    - memory
    - randomness
    - tty
    - audit
    - pam
  - hw
    - audio
    - printing
    - bluetooth
    - modules
    - sysctl

### profiles

- devcontainer??
- serv
  - [selinux](https://nixos.wiki/wiki/Workgroup:SELinux) questionmark?

## misc

- interesting project
  - [spectrum os](https://spectrum-os.org/doc/installation/getting-spectrum.html)
- another one
  - [mobile nixos](https://github.com/mobile-nixos/mobile-nixos)
- [testing](https://nix.dev/tutorials/nixos/integration-testing-using-virtual-machines.html)
