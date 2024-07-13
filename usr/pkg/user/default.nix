{ inputs, pkgs, ... }: {
  imports = [
    ./user.nix
    ./tmux.nix
    ./alacritty.nix
    ./vim.nix
    ./nixvim
    # inputs.nixvim.homeManagerModules.nixvim
  ];
  #home.packages = [ inputs.nixvim.packages.${pkgs.system}.default ];
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     neovim = inputs.omega-nixvim.packages.${prev.system}.default;
  #   })
  # ];
  # programs.neovim.enable = true;
}
