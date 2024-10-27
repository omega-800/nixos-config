{
  programs.nixvim = {
    keymaps = [
      # Git    
      {
        mode = "n";
        key = "<leader>g";
        action = "+git";
      }
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit (root dir)";
        };
      }
      {
        mode = "n";
        key = "<leader>gt";
        action = "+toggles";
      }
      {
        key = "<leader>gtb";
        action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
        options.desc = "Gitsigns current line blame";
      }
      {
        key = "<leader>gtd";
        action = "<CMD>Gitsigns toggle_deleted";
        options.desc = "Gitsigns deleted";
      }
      {
        key = "<leader>gd";
        action = "<CMD>Gitsigns diffthis<CR>";
        options.desc = "Gitsigns diff this buffer";
      }
      {
        mode = "n";
        key = "<leader>gr";
        action = "+resets";
      }
      {
        key = "<leader>grh";
        action = "<CMD>Gitsigns reset_hunk<CR>";
        options.desc = "Gitsigns reset hunk";
      }
      {
        key = "<leader>grb";
        action = "<CMD>Gitsigns reset_buffer<CR>";
        options.desc = "Gitsigns reset current buffer";
      }
    ];
    plugins = {
      gitlinker = {
        enable = true;
        callbacks = {
          "github.com" = "get_github_type_url";
          "git.getonline.ch" = "get_gitlab_type_url";
          "gitlab.com" = "get_gitlab_type_url";
          "try.gitea.io" = "get_gitea_type_url";
          "codeberg.org" = "get_gitea_type_url";
          "bitbucket.org" = "get_bitbucket_type_url";
          "try.gogs.io" = "get_gogs_type_url";
          "git.sr.ht" = "get_srht_type_url";
          "git.launchpad.net" = "get_launchpad_type_url";
          "repo.or.cz" = "get_repoorcz_type_url";
          "git.kernel.org" = "get_cgit_type_url";
          "git.savannah.gnu.org" = "get_cgit_type_url";
        };
      };
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = true;
          trouble = true;
          signs = {
            add = {
              text = " ";
            };
            change = {
              text = " ";
            };
            delete = {
              text = " ";
            };
            untracked = {
              text = "";
            };
            topdelete = {
              text = "󱂥 ";
            };
            changedelete = {
              text = "󱂧 ";
            };
          };
        };
      };
      lazygit.enable = true;
      git-worktree = {
        enable = true;
        enableTelescope = true;
      };
    };
    extraConfigLua = ''
      require("telescope").load_extension("lazygit")
    '';
  };
}
