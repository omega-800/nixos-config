{ inputs, pkgs, ... }: {
  #imports = [ inputs.nur.nixosModules.nur ];
  environment.systemPackages = with pkgs;[ nur.repos.wolfangaukang.mouseless ];
}
