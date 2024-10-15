{ pkgs, ... }: {
  u.user.nixvim.enable = true;
  # TODO: programs.dconf
  home.packages = with pkgs; [ qemu virt-manager dconf ];
}
