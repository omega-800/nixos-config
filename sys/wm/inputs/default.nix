{ inputs, pkgs, ... }: {
  #imports = [ inputs.nur.nixosModules.nur ];
  environment.systemPackages = [ pkgs.nur.repos.wolfangaukang.mouseless ];
}
