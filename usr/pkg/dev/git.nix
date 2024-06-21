{ lib, config, pkgs, ... }: 
with lib;
let cfg = config.u.dev;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git-secrets
    ];
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = usr.devName;
      userEmail = usr.devEmail;
      prompt.enable = true;
      aliases = {
        ci = "commit";
        co = "checkout";
        s = "status";
        p = "pull";
      };
      config = {
        init.defaultBranch = "main";
      };
      extraConfig = {
        credential.helper = "${pkgs.git.override { withLibSecret = true; }}/bin/git-credential-libsecret";
        push.autoSetupRemote = true;
      }; 
#pkgs.pinentry-tty;
      diff-so-fancy = {
        enable = true;
        changeHunkIndicators = true;
        markEmptyLines = true;
      };
      ignores = [ "*.swp" ];
    };
  };
}
