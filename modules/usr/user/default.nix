{ inputs, pkgs, usr, ... }: {
  imports = [
    ./user.nix
    ./tmux.nix
    ./vim.nix
    ./dirs.nix
    ./term
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
