# omega's super-awesome, ultra-modular, blazingly-fast, dazzlingly-beautiful, polarizingly-opinionated and fairly-bloated nix config

## new to nix? confused?

Me too, here are some resources to make the learning experience more fun and the errors less cryptic:

### nix

- [homepage](https://nixos.org/)
- [nix-pills](https://nixos.org/guides/nix-pills/)
- [nix.dev](https://nix.dev/manual/nix/2.23/introduction)
- [nix dsl](https://noogle.dev)
- commands: `man nix`
- repl: `man nix3-repl`
- [vimjoyer (youtube)](https://www.youtube.com/@vimjoyer)
- [librephoenix (youtube)](https://www.youtube.com/@librephoenix)

### nixPkgs

- [src](https://github.com/NixOS/nixpkgs)
- [search](https://search.nixos.org/packages)

### nixOS

- [install guide](https://nixos.org/manual/nixos/stable/#sec-installation)
- [unofficial (yet very informative) nixOS + flakes book](https://nixos-and-flakes.thiscute.world/)
- config options: `man configuration.nix`
- [servers](https://sidhion.com/blog/posts/nixos_server_issues/)
- [give them some love](https://aldoborrero.com/posts/2023/01/15/setting-up-my-machines-nix-style/)
- [secrets](https://lgug2z.com/articles/handling-secrets-in-nixos-an-overview/)
- [examples of modules](https://github.com/NuschtOS/nixos-modules)

### home-manager

- [src](https://github.com/nix-community/home-manager)
- [manual](https://nix-community.github.io/home-manager/)
- config options: `man home-configuration.nix`

### virtualization

- [microvm](https://github.com/astro/microvm.nix)
- [proxmox](https://github.com/SaumonNet/proxmox-nixos)
- [libvirt](https://nixos.wiki/wiki/Libvirt)
- [nixvirt](https://github.com/AshleyYakeley/NixVirt)

## now onto the config

This frosty amalgamation of files allows for reproducible environment builds without sacrificing customization options. Here's a quick overview:

```
src
├── apps                (custom apps)
├── pkgs                (custom packages)
├── shells              (devShells)
├── modules             (config modules)
│   ├── omega           (custom options + variables for global use)
│   ├── home            (home-manager)
│   ├── droid           (nix-on-droid)
│   ├── nixos           (nixos)
│   └── system          (system-manager)
├── configs             (configurations)
│   ├── nodes           (host profiles)
│   └── profiles        (hosts)
├── lib                 (custom lib)
│   ├── flake           (flake utils)
│   └── omega           (my lib)
├── themes              (themes for modules)
├── secrets             (please don't look)
```

The important files (where your customization happens) are:

### configs/\*

Host-specific configurations.

#### profiles/\*

Different profiles with different defaults for different use-cases. Can be set per-host through the option `sys.profile`.

##### default/\*

Default configs which get applied to all of the hosts.

###### options.nix

Here live all of the options (which ideally should be set inside of hosts/${hostname}/config.nix) as well as their defaults.

```
# assuming your pwd is the root of this repo
nix repl
# now you'll be teleported to the nix repl shell
# :lf means load flake (the one in the current directory)
:lf .
# show options for the home-manager module of host
homeConfigurations.${hostname}.options
# show options for my custom home-manager options to activate pre-configured modules
homeConfigurations.${hostname}.options.u
# :q for quitting the repl
:q
```

##### work/\*

Defaults for my work machine, duh.

##### pers/\*

Defaults for my personal desktops.

##### serv/\*

Defaults for servers or minimal installations.

#### nodes/${hostname}/\*

Specific hosts with their own configs.

##### config.nix

In this file the previously mentioned options are set, and defaults get overridden.
**IMPORTANT:** sys.system _MUST_ be set!

##### home.nix

If this file is present, then a homeManagerConfiguration flake output is created, which can be applied by running `hms`, which is an alias for `home-manager switch --flake /home/${username}/ws/nixos-config#${hostname}`.

##### nixos.nix

If this file is present, then a nixosSystem flake output is created, which can be applied by running `nrs`, which is an alias for `nixos-rebuild switch --flake /home/${username}/ws/nixos-config#${hostname}`.

##### hardware-configuration.nix

This file can be present if running nixOS (and not the standalone home-manager) to include hardware-specific configs.

##### system.nix

If this file is present, then a systemConfigs flake output is created for generic distros using system-manager.

##### droid.nix

If this file is present, then a nixOnDroidConfigurations flake output is created for android devices using the nix package manager with nix-on-droid.
