{ userSettings, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = userSettings.devName;
    userEmail = userSettings.devEmail;
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
}
