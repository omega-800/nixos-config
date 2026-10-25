{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  enabled = elem "tidal" config.u.user.nixvim.langSupport;
  losc = pkgs.lua55Packages.buildLuarocksPackage rec {
    pname = "losc";
    version = "1.0.1-1";
    rockspecFilename = "rockspecs/losc-1.0.1-1.rockspec";

    src = pkgs.fetchFromGitHub {
      owner = "davidgranstrom";
      repo = pname;
      rev = "12691509e066eded1a2c9fbf480b68ba9b697c2a";
      hash = "sha256-gxDQkPy9Nsyh9uFXcT+XyKo7mPEZ6ZeDIYgCM0h/Jbo=";
    };

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.cmake
    ];
    buildInputs = [ pkgs.luajit ];
  };
  tidal-nvim = pkgs.vimUtils.buildVimPlugin rec {
    pname = "tidal.nvim";
    version = "0.1.0";
    src = pkgs.fetchFromCodeberg {
      owner = "MrReason";
      repo = pname;
      rev = "b9233c1208e3e7e632d767efa94c7f7606245a55";
      hash = "sha256-abvmMn8pi/bQS/EeB653K+IZyMFjGEuDkhc4tVIMdcY=";
    };
    dependencies = [ losc ];
    nvimSkipModules = [
      "losc.benchmarks.init"
      "losc.examples.client"
      "losc.examples.server"
      "losc.src.losc.plugins.udp-socket"
    ];
  };
  inherit (lib.omega.vim) keyG key;
in
{
  config = mkIf enabled {
    programs.nixvim = {
      # keymaps = keyG "<leader>t" "misc" [
      # ];
      extraPlugins = [ tidal-nvim ];

      extraConfigLua = ''
        require('tidal').setup()
      '';
    };
  };
}
