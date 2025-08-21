{
  sys,
  usr,
  lib,
  config,
  pkgs,
  globals,
  ...
}:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.u.dev.git;
in
{
  options.u.dev.git.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable;
  };

  config = mkIf cfg.enable {
    # services.gnome-keyring = {
    #   enable = true;
    #   components = [ "ssh" "secrets" ];
    # };
    programs.gpg = {
      enable = true;
      homedir = globals.envVars.GNUPGHOME;
    };
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      # TODO:
      enableSshSupport = false;
      defaultCacheTtl = 30;
      defaultCacheTtlSsh = 30;
      maxCacheTtl = 600;
      maxCacheTtlSsh = 600;
      # extraConfig = ''
      #   allow-loopback-pinentry
      # '';
      pinentryPackage = pkgs.pinentry-tty;
      grabKeyboardAndMouse = true;
    };
    home.packages = with pkgs; [ git-secrets ] ++ (optionals (!usr.minimal) [ lazygit ]);
    programs.git = {
      enable = true;
      package = pkgs.gitFull;
      userName = usr.devName;
      userEmail = usr.devEmail;
      aliases = {
        a = "add";
        ci = "commit -m";
        co = "checkout";
        s = "status";
        ss = "submodule status";
        su = "submodule update --init --merge --recursive --remote";
        sl = "stash list";
        sps = "stash push .";
        sp = "stash pop";
        f = "fetch";
        p = "pull";
        d = "diff";
        ps = "push";
        m = "merge";
        l = "log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'";
        alias = "config --get-regexp ^alias";
      };
      extraConfig = mkMerge [
        # https://github.com/Kicksecure/security-misc/blob/master/etc/gitconfig
        (mkIf sys.hardened {
          core.symlinks = false;
          transfer.fsckobjects = true;
          fetch.fsckobjects = true;
          receive.fsckobjects = true;
        })
        (mkIf sys.paranoid {
          commit.gpgsign = true;
          merge.verifySignatures = true;
        })
        {

          init.defaultBranch = "main";
          status = {
            branch = true;
            showStash = true;
            showUntrackedFiles = true;
          };
          credential =
            #if sys.profile == "pers" && usr.extraBloat then
            #  {
            #    # kms
            #    credentialStore = "secretservice";
            #    helper = "${pkgs.nur.repos.utybo.git-credential-manager}/bin/git-credential-manager";
            #  }
            #else
            {
              helper = "libsecret";
              # helper = "oauth";
              # helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
              # helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
            };
          push = {
            autoSetupRemote = true;
            default = "current";
            followTags = true;
          };
          pull.default = "current";
          rebase.missingCommitsCheck = "warn";
          apply.whitespace = "error";
          # FIXME:
          safe.directory = "*";
          branch.sort = "-committerdate";
          tag.sort = "-taggerdate";
          pager = {
            branch = false;
            tag = false;
          };
          log = {
            abbrevCommit = true;
            graphColors = "blue,yellow,cyan,magenta,green,red";
          };
          core = {
            compression = 9;
            whitespace = "blank-at-eof,blank-at-eol,space-before-tab,trailing-space,tabwidth=${toString config.programs.nixvim.opts.tabstop}";
            preloadindex = true;
          };
          advice = {
            addEmptyPathspec = false;
            pushNonFastForward = false;
            statusHints = false;
          };
          url = {
            "git@github.com:${usr.devName}/" = {
              insteadOf = "gh:";
            };
            "git@gitlab.com:${usr.devName}/" = {
              insteadOf = "gl:";
            };
          };
        }
      ];
      diff-so-fancy = {
        enable = true;
        changeHunkIndicators = true;
        markEmptyLines = true;
      };
      ignores = [
        "*.swp"
        "node_modules"
        "*.out"
      ];
      hooks = {
        pre-commit = ./pre-commit;
        commit-msg = ./commit-msg;
        prepare-commit-msg = ./prepare-commit-msg;
      };
      # TODO:
      # https://github.com/gitattributes/gitattributes/tree/master
      attributes = [ ];
    };
  };
}
