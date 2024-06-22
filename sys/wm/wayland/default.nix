{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ 
    wayland
  ];
}
