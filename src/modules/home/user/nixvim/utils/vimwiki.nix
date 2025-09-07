{ globals, ... }:
{
  programs.nixvim.plugins = {
    cmp-vimwiki-tags.enable = true;
    vimwiki = {
      enable = true;
      settings = {
        list =
          map
            (path: {
              inherit path;
              ext = ".md";
              syntax = "markdown";
            })
            (
              with globals.envVars;
              if sys.profile == "pers" then
                [
                  "${XDG_DOCUMENTS_DIR}/pers/notes"
                  "${XDG_DOCUMENTS_DIR}/pers/diary"
                ]
              else if sys.profile == "school" then
                [
                  "${XDG_DOCUMENTS_DIR}/school/notes"
                  "${XDG_DOCUMENTS_DIR}/school/projects"
                ]
              else
                [ ]
            );
      };
    };
  };
}
