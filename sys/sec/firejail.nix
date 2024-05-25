{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ firejail ];
  programs.firejail.enable = true;
  programs.firejail.wrappedBinaries = {};
}
