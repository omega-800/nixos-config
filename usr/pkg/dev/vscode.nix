{ usr, lib, config, pkgs, ... }:
with lib;
let cfg = config.u.dev.vscode;
in {
  options.u.dev.vscode.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ciscoPacketTracer8" ];
    home.packages = with pkgs; [ ];
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = false;
      mutableExtensionsDir = true;
      extensions = with pkgs.vscode-extensions; [ bbenoist.nix vscodevim.vim ];
      globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      keybindings = [
        {
          "key" = "space e";
          "command" = "workbench.action.toggleSidebarVisibility";
          "when" = "filesExplorerFocus && !inputFocus";
        }
        {
          "key" = "a";
          "command" = "explorer.newFile";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "f";
          "command" = "explorer.newFolder";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "r";
          "command" = "renameFile";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "x";
          "command" = "filesExplorer.cut";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "y";
          "command" = "filesExplorer.copy";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !inputFocus";
        }
        {
          "key" = "p";
          "command" = "filesExplorer.paste";
          "when" =
            "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "h";
          "command" = "editor.action.scrollLeftHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "j";
          "command" = "editor.action.scrollDownHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "k";
          "command" = "editor.action.scrollUpHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "l";
          "command" = "editor.action.scrollRightHover";
          "when" = "editorHoverFocused";
        }
        {
          "key" = "ctrl+alt+t";
          "command" = "workbench.action.terminal.focus";
        }
        {
          "key" = "ctrl+alt+t";
          "command" = "workbench.action.focusActiveEditorGroup";
          "when" = "terminalFocus";
        }
      ];

      userSettings = {
        "editor.defaultFormatter" = "biomejs.biome";
        "editor.formatOnSave" = true;
        "workbench.activityBar.location" = "top";
        "window.customTitleBarVisibility" = "auto";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "editor.cursorSurroundingLines" = 8;
        "zenMode.hideStatusBar" = false;
        "zenMode.hideActivityBar" = false;
        "zenMode.restore" = true;
        "vim.smartRelativeLine" = true;
        "vim.useSystemClipboard" = false;
        "vim.vimrc.enable" = true;
        "vim.vimrc.path" = "${globals.envVars.HOME}/.vimrc";
        "vim.leader" = "<space>";
        "vim.highlightedyank.enable" = true;
        "vim.highlightedyank.color" = "#a9dc7660";
        "vim.highlightedyank.duration" = 250;
        "vim.hlsearch" = true;
        "vim.enableNeovim" = false;
        "vim.statusBarColorControl" = false;
        "editor.renderWhitespace" = "selection";
        "editor.cursorStyle" = "line";
        "editor.cursorSmoothCaretAnimation" = "off";
        "vim.statusBarColors.normal" = [ "#8FBCBB" "#434C5E" ];
        "vim.statusBarColors.insert" = "#BF616A";
        "vim.statusBarColors.visual" = "#B48EAD";
        "vim.statusBarColors.visualline" = "#B48EAD";
        "vim.statusBarColors.visualblock" = "#A3BE8C";
        "vim.statusBarColors.replace" = "#D08770";
        "vim.statusBarColors.commandlineinprogress" = "#007ACC";
        "vim.statusBarColors.searchinprogressmode" = "#007ACC";
        "vim.statusBarColors.easymotionmode" = "#007ACC";
        "vim.statusBarColors.easymotioninputmode" = "#007ACC";
        "vim.statusBarColors.surroundinputmode" = "#007ACC";
        "extensions.experimental.affinity" = { "vscodevim.vim" = 1; };
        "workbench.colorCustomizations" = {
          "statusBar.background" = "#8FBCBB";
          "statusBar.noFolderBackground" = "#8FBCBB";
          "statusBar.debuggingBackground" = "#8FBCBB";
          "statusBar.foreground" = "#434C5E";
          "statusBar.debuggingForeground" = "#434C5E";
        };
        "vim.normalModeKeyBindings" = [
          {
            "before" = [ "<leader>" "e" ];
            "commands" = [ "workbench.view.explorer" ];
          }
          {
            "before" = [ "<leader>" "q" ];
            "commands" = [ "workbench.action.closeActiveEditor" ];
          }
          {
            "before" = [ "g" "p" "d" ];
            "commands" = [ "editor.action.peekDefinition" ];
          }
          {
            "before" = [ "g" "h" ];
            "commands" = [ "editor.action.showDefinitionPreviewHover" ];
          }
          {
            "before" = [ "g" "i" ];
            "commands" = [ "editor.action.goToImplementation" ];
          }
          {
            "before" = [ "g" "p" "i" ];
            "commands" = [ "editor.action.peekImplementation" ];
          }
          {
            "before" = [ "g" "q" ];
            "commands" = [ "editor.action.quickFix" ];
          }
          {
            "before" = [ "g" "r" ];
            "commands" = [ "editor.action.referenceSearch.trigger" ];
          }
          {
            "before" = [ "g" "t" ];
            "commands" = [ "editor.action.goToTypeDefinition" ];
          }
          {
            "before" = [ "g" "p" "t" ];
            "commands" = [ "editor.action.peekTypeDefinition" ];
          }
        ];
        "yaml.schemas" = {
          "file:///home/dev/.vscode-server/extensions/atlassian.atlascode-3.0.10/resources/schemas/pipelines-schema.json" =
            "bitbucket-pipelines.yml";
        };
        "atlascode.bitbucket.enabled" = false;
        "atlascode.jira.jqlList" = [{
          "id" = "335c6fc6-665c-4824-8650-bd001433c6e1";
          "enabled" = true;
          "name" = "My inteco Issues";
          "query" =
            "assignee = currentUser() AND resolution = Unresolved ORDER BY lastViewed DESC";
          "siteId" = "f70fc1d1-2771-4603-b0f4-aa6f2f6a6c06";
          "monitor" = true;
        }];
        "[liquid]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
        "redhat.telemetry.enabled" = false;
        "vim.digraphs" = { };
        "[typescript]" = { "editor.defaultFormatter" = "biomejs.biome"; };
        "[vue]" = { "editor.defaultFormatter" = "Vue.volar"; };
      };
    };
  };
}
