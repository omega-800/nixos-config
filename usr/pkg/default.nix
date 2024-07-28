{ config, lib, ... }: with lib; {
  options.u.extraPkgs = mkOption {
	type = types.listOf types.package;
	default = [];
}; 
  imports = [
    ./dev
    ./style 
    ./work
    ./file
    ./media
    ./net
    ./office
    ./social
    ./user
    ./utils
  ];
config.home.packages = config.u.extraPkgs;
}
