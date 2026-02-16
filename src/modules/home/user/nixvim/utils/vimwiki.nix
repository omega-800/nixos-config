{
  globals,
  sys,
  lib,
  ...
}:
{
  programs.nixvim = {
    # kinda frustrating, ngl
    extraConfigVim = ''
      let g:vimwiki_key_mappings =
      \ {
      \   'all_maps': 1,
      \   'global': 1,
      \   'headers': 0,
      \   'text_objs': 0,
      \   'table_format': 0,
      \   'table_mappings': 0,
      \   'lists': 0,
      \   'lists_return': 0,
      \   'links': 1,
      \   'html': 1,
      \   'mouse': 0,
      \ }
      let g:vimwiki_conceallevel=0
      let g:vimwiki_table_mappings=0
      let g:vimwiki_table_auto_fmt=0
    '';
    plugins = {
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
                # TODO: specialisations
                (lib.optionals
                  (builtins.any (lib.flip builtins.elem sys.profile) [
                    "pers"
                    "gaymer"
                  ])
                  [
                    "${globals.envVars.XDG_DOCUMENTS_DIR}/pers/notes"
                    "${globals.envVars.XDG_DOCUMENTS_DIR}/pers/diary"
                  ]
                )
                ++ (lib.optionals (builtins.elem "school" sys.profile) [
                  "${globals.envVars.XDG_DOCUMENTS_DIR}/school/notes"
                  "${globals.envVars.XDG_DOCUMENTS_DIR}/school/projects"
                ])
              );
        };
      };
    };
  };
}
