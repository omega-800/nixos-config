{ pkgs, ... }:
{
  imports = [
    ./tools.nix
    ./docker.nix
    ./mysql.nix
    ./psql.nix
    ./virt.nix
    ./orchestration.nix
    ./android.nix
  ];
  environment.systemPackages = [ pkgs.gitAndTools.gitFull ];
}
