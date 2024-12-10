{
  globals,
  usr,
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.u.dev.vscode;
in
{
  options.u.dev.vscode.enable = mkOption {
    type = types.bool;
    default = config.u.dev.enable && usr.extraBloat;
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "vscode" ];
    home.packages = with pkgs; [ ];
    programs.vscode = {
      enable = true;
      enableExtensionUpdateCheck = true;
      enableUpdateCheck = false;
      mutableExtensionsDir = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        vscodevim.vim
      ];
      globalSnippets = {
        fixme = {
          body = [ "$LINE_COMMENT FIXME: $0" ];
          description = "Insert a FIXME remark";
          prefix = [ "fixme" ];
        };
      };
      keybindings = [
        {
          "key" = "ctrl+tab";
          "command" = "workbench.action.nextEditor";
        }
        {
          "key" = "ctrl+shift+tab";
          "command" = "workbench.action.previousEditor";
        }
        {
          "key" = "space e";
          "command" = "workbench.action.toggleSidebarVisibility";
          "when" = "filesExplorerFocus && !inputFocus";
        }
        {
          "key" = "a";
          "command" = "explorer.newFile";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "f";
          "command" = "explorer.newFolder";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "r";
          "command" = "renameFile";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "x";
          "command" = "filesExplorer.cut";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !explorerResourceReadonly && !inputFocus";
        }
        {
          "key" = "y";
          "command" = "filesExplorer.copy";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceIsRoot && !inputFocus";
        }
        {
          "key" = "p";
          "command" = "filesExplorer.paste";
          "when" = "explorerViewletVisible && filesExplorerFocus && !explorerResourceReadonly && !inputFocus";
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

      userSettings = with config.lib.stylix.colors; {
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.formatOnSave" = true;
        "workbench.activityBar.location" = "top";
        "window.customTitleBarVisibility" = "auto";
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
        "vim.highlightedyank.color" = "#${base09}";
        "vim.highlightedyank.duration" = 250;
        "vim.hlsearch" = true;
        "vim.enableNeovim" = false;
        "vim.statusBarColorControl" = false;
        "editor.renderWhitespace" = "selection";
        "editor.cursorStyle" = "line";
        "editor.cursorSmoothCaretAnimation" = "off";
        "vim.statusBarColors.normal" = [
          "#${base0D}"
          "#${base02}"
        ];
        "vim.statusBarColors.insert" = "#${base0B}";
        "vim.statusBarColors.visual" = "#${base0E}";
        "vim.statusBarColors.visualline" = "#${base0E}";
        "vim.statusBarColors.visualblock" = "#${base0E}";
        "vim.statusBarColors.replace" = "#${base08}";
        "vim.statusBarColors.commandlineinprogress" = "#${base07}";
        "vim.statusBarColors.searchinprogressmode" = "#${base07}";
        "vim.statusBarColors.easymotionmode" = "#${base07}";
        "vim.statusBarColors.easymotioninputmode" = "#${base07}";
        "vim.statusBarColors.surroundinputmode" = "#${base07}";
        "extensions.experimental.affinity" = {
          "vscodevim.vim" = 1;
        };
        "workbench.colorCustomizations" = {
          "statusBar.background" = "#${base0C}";
          "statusBar.noFolderBackground" = "#${base0C}";
          "statusBar.debuggingBackground" = "#${base0C}";
          "statusBar.foreground" = "#${base04}";
          "statusBar.debuggingForeground" = "#${base04}";
        };
        "vim.normalModeKeyBindings" = [
          {
            "before" = [
              "<leader>"
              "e"
            ];
            "commands" = [ "workbench.view.explorer" ];
          }
          {
            "before" = [
              "<leader>"
              "q"
            ];
            "commands" = [ "workbench.action.closeActiveEditor" ];
          }
          {
            "before" = [
              "g"
              "p"
              "d"
            ];
            "commands" = [ "editor.action.peekDefinition" ];
          }
          {
            "before" = [
              "g"
              "h"
            ];
            "commands" = [ "editor.action.showDefinitionPreviewHover" ];
          }
          {
            "before" = [
              "g"
              "i"
            ];
            "commands" = [ "editor.action.goToImplementation" ];
          }
          {
            "before" = [
              "g"
              "p"
              "i"
            ];
            "commands" = [ "editor.action.peekImplementation" ];
          }
          {
            "before" = [
              "g"
              "q"
            ];
            "commands" = [ "editor.action.quickFix" ];
          }
          {
            "before" = [
              "g"
              "r"
            ];
            "commands" = [ "editor.action.referenceSearch.trigger" ];
          }
          {
            "before" = [
              "g"
              "t"
            ];
            "commands" = [ "editor.action.goToTypeDefinition" ];
          }
          {
            "before" = [
              "g"
              "p"
              "t"
            ];
            "commands" = [ "editor.action.peekTypeDefinition" ];
          }
        ];
        "yaml.schemas" = {
          "file:///home/dev/.vscode-server/extensions/atlassian.atlascode-3.0.10/resources/schemas/pipelines-schema.json" = "bitbucket-pipelines.yml";
        };
        "atlascode.bitbucket.enabled" = false;
        "redhat.telemetry.enabled" = false;
        "vim.digraphs" = { };
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[vue]" = {
          "editor.defaultFormatter" = "Vue.volar";
        };
        "[liquid]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
      };
    };
  };
}
