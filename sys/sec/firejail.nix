{ lib, sys, usr, pkgs, ... }: {
  config = lib.mkIf (sys.hardened && !usr.minimal) {
    security.chromiumSuidSandbox.enable = true;
    environment.systemPackages = with pkgs; [ firejail ];
    programs.firejail = {
      enable = true;
      wrappedBinaries = {
        firefox = {
          executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
          profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
        };
        chromium = {
          executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
          profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
        };
        discord = {
          executable = "${pkgs.lib.getBin pkgs.discord}/bin/discord";
          profile = "${pkgs.firejail}/etc/firejail/discord.profile";
        };
        brave = {
          executable = "${pkgs.lib.getBin pkgs.brave}/bin/brave";
          profile = "${pkgs.firejail}/etc/firejail/brave.profile";
        };
        code = {
          executable = "${pkgs.lib.getBin pkgs.vscode}/bin/vscode";
          profile = "${pkgs.firejail}/etc/firejail/code.profile";
        };
        nodejs_22 = {
          executable = "${pkgs.lib.getBin pkgs.nodejs_22}/bin/nodejs_22";
          profile = "${pkgs.firejail}/etc/firejail/nodejs_22.profile";
        };
        postman = {
          executable = "${pkgs.lib.getBin pkgs.postman}/bin/postman";
          profile = "${pkgs.firejail}/etc/firejail/postman.profile";
        };
      };
    };
  };
}
