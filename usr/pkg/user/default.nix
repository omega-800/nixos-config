{ inputs, pkgs, ... }: {
  imports = [
    ./user.nix
    ./tmux.nix
    ./alacritty.nix
    ./vim.nix
    #./nixvim
    #inputs.nixvim.homeManagerModules.nixvim
  ];
  home.packages = [ inputs.nixvim.packages.${pkgs.system}.default ];
}
