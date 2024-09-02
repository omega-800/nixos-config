# omega's super-awesome, ultra-modular, blazingly-fast, dazzlingly-beautiful, polarizingly-opinionated and fairly-bloated nix config

## new to nix? confused?

Me too, here are some resources to make the learning experience more fun and the errors less cryptic:

### nix

- [homepage](https://nixos.org/)
- [nix-pills](https://nixos.org/guides/nix-pills/)
- [nix.dev](https://nix.dev/manual/nix/2.23/introduction)
- commands: `man nix`
- repl: `man nix3-repl`

### nixPkgs

- [src](https://github.com/NixOS/nixpkgs)
- [search](https://search.nixos.org/packages)

### nixOS

- [install guide](https://nixos.org/manual/nixos/stable/#sec-installation)
- [unofficial (yet very informative) nixOS + flakes book](https://nixos-and-flakes.thiscute.world/)
- config options: `man configuration.nix`

### home-manager

- [src](https://github.com/nix-community/home-manager)
- [manual](https://nix-community.github.io/home-manager/)
- config options: `man home-configuration.nix`

## now onto the config

This frosty amalgamation of files allows for reproducible environment builds without sacrificing customization options. The important files (where your customization happens) are:

### profiles/\*

Different profiles with different defaults for different use-cases. Can be set per-host through the option `sys.profile`.

#### default/\*

Default configs which get applied to all of the hosts.

##### options.nix

Here live all of the options (which ideally should be set inside of hosts/${hostname}/config.nix) as well as their defaults.
```
# assuming your pwd is the root of this repo
nix repl
# now you'll be teleported to the nix repl shell
# :lf means load flake (the one in the current directory)
:lf .
# show options for the home-manager module of host 
homeConfigurations.${hostname}.options
# :q for quitting the repl
:q
```

#### work/\*

Defaults for my work machine, duh.

#### pers/\*

Defaults for my personal desktop(s?).

#### serv/\*

Defaults for servers or minimal installations.

### hosts/${hostname}/\*

Specific hosts with their own configs.

#### config.nix

In this file the previously mentioned options are set, and defaults get overridden.
**IMPORTANT:** sys.{hostname,system} _MUST_ be set!

#### home.nix

If this file is present, then a homeManagerConfiguration flake output is created, which can be applied by running `hms`, which is an alias for `home-manager switch --flake /home/${username}/ws/nixos-config#${hostname}`.

#### configuration.nix

If this file is present, then a nixosSystem flake output is created, which can be applied by running `nrs`, which is an alias for `nixos-rebuild switch --flake /home/${username}/ws/nixos-config#${hostname}`.

#### hardware-configuration.nix

This file can be present if running nixOS (and not the standalone home-manager).

## omega's cool help functions 

`SUPER+SHIFT+H`: list sxhkd shortcuts, select to copy
