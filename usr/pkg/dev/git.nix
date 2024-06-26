{ usr, lib, config, pkgs, ... }: 
with lib;
let cfg = config.u.dev;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git-secrets
    ];
    programs.git = mkIf cfg.enable {
      enable = true;
      package = pkgs.gitFull;
      userName = usr.devName;
      userEmail = usr.devEmail;
      aliases = {
        ci = "commit -m";
        co = "checkout";
        s = "status";
        p = "pull";
        ps = "push";
        alias = "config --get-regexp ^alias";
      };
      extraConfig = {
        init.defaultBranch = "main";
        credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
        push.autoSetupRemote = true;
      }; 
#pkgs.pinentry-tty;
      diff-so-fancy = {
        enable = true;
        changeHunkIndicators = true;
        markEmptyLines = true;
      };
      ignores = [ "*.swp" "node_modules" ];
    };
  };
}
