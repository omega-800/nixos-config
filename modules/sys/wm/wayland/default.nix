{ config, pkgs, ... }: {
  imports = [ ./swhkd.nix ];
  environment.systemPackages = with pkgs; [
    # why do i need this again?
    wayland
    lxqt.lxqt-policykit
  ];
}
