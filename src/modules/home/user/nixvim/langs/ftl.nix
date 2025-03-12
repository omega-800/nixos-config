{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "ftl" config.u.user.nixvim.langSupport;
in
{
  config.programs.nixvim = mkIf enabled {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin rec {
      name = "vim-freemarker";
      src = pkgs.fetchFromGitHub {
        repo = name;
        owner = "andreshazard";
        rev = "993bda23e72e4c074659970c1e777cb19d8cf93e";
        hash = "sha256-g4GnutHqxOH0rhZZmx7YpqFWZ9a+lTC6SdNYvVrSPbY=";
      };
    })];
    # extraConfigLua = "require('vim-freemarker');";
  };
}
