{ usr, ... }: {
  imports = [ 
    ./aliases.nix
    ./${usr.shell.pname}.nix
    #./zsh.nix
    #./bash.nix
    ./posix.nix
  ];
}
