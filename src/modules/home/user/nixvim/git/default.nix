{ lib, ... }:
let
  inherit (lib.omega.vim) keyG key;
in
{
  programs.nixvim = {
    keymaps = keyG "<leader>g" "git" (
      (keyG "t" "toggles" [
        (key "n" "b" "<CMD>Gitsigns toggle_current_line_blame<CR>" "Gitsigns current line blame")
        (key "n" "d" "<CMD>Gitsigns toggle_deleted<CR>" "Gitsigns deleted")
      ])
      ++ (keyG "r" "resets" [
        (key "n" "h" "<CMD>Gitsigns reset_hunk<CR>" "Gitsigns reset hunk")
        (key "n" "b" "<CMD>Gitsigns reset_buffer<CR>" "Gitsigns reset buffer")
      ])
      ++ [
        (key "n" "d" "<CMD>Gitsigns diffthis<CR>" "Gitsigns diff this buffer")
      ]
    );
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
            add.text = " ";
            change.text = " ";
            delete.text = " ";
            untracked.text = "";
            topdelete.text = "󱂥 ";
            changedelete.text = "󱂧 ";
          };
        };
      };
      git-worktree = {
        enable = true;
        enableTelescope = true;
      };
    };
  };
}
