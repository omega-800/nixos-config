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
          "key" = "d";
          "command" = "deleteFile";
          "when" = "filesExplorerFocus && foldersViewVisible && !explorerResourceReadonly && !inputFocus && !treeFindOpen";
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
        # telemetry (copium)
        "telemetry.telemetryLevel" = "off";
        "telemetry.enableTelemetry" = false;
        "telemetry.enableCrashReporter" = false;
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "workbench.enableExperiments" = false;
        "redhat.telemetry.enabled" = false;
        "update.channel" = "none";
        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = false;
        "git.enabled" = false;
        "typescript.tsserver.enableRegionDiagnostics" = false;
        "typescript.surveys.enabled" = false;
        "typescript.tsserver.experimental.enableProjectDiagnostics" = false;
        # performance (copium)
        "editor.renderWhitespace" = "none";
        "files.autoGuessEncoding" = false;
        "files.watcherExclude" = {
          "/.git/objects/" = true;
          "/.git/subtree-cache/" = true;
          "/node_modules/" = true;
        };
        "search.exclude" = {
          "/node_modules" = true;
          "/bower_components" = true;
        };
        "workbench.tips.enabled" = false;
        "explorer.openEditors.visible" = 1;
        "editor.minimap.enabled" = false;
        "editor.codeLens" = false;
        "editor.formatOnPaste" = false;
        # quality of life
        "extensions.ignoreRecommendations" = true;
        "editor.cursorBlinking" = "blink";
        "editor.formatOnSave" = true;
        "editor.wordWrap" = "off";
        "editor.cursorSurroundingLines" = 8;
        "editor.defaultFormatter" = "esbenp.prettier-vscode";
        "editor.cursorStyle" = "line";
        "editor.cursorSmoothCaretAnimation" = "off";
        "editor.rulers" = [
          {
            column = 80;
            color = "#${base02}";
          }
          {
            column = 120;
            color = "#${base0D}";
          }
        ];
        "workbench.colorCustomizations" = {
          "statusBar.background" = "#${base0C}";
          "statusBar.noFolderBackground" = "#${base0C}";
          "statusBar.debuggingBackground" = "#${base0C}";
          "statusBar.foreground" = "#${base04}";
          "statusBar.debuggingForeground" = "#${base04}";
        };
        "workbench.activityBar.location" = "top";
        "window.customTitleBarVisibility" = "auto";
        "zenMode.hideStatusBar" = false;
        "zenMode.hideActivityBar" = false;
        "zenMode.restore" = true;
        # vim
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
        "vim.digraphs" = { };
        "extensions.experimental.affinity" = {
          "vscodevim.vim" = 1;
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
              "K"
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
        # plugins
        "atlascode.bitbucket.enabled" = false;
        "[typescript]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "[vue]" = {
          "editor.defaultFormatter" = "Vue.volar";
        };
        "[liquid]" = {
          "editor.defaultFormatter" = "vscode.html-language-features";
        };
        # bloat
        "javascript.updateImportsOnFileMove.enabled" = "never";
        # "typescript.tsserver.log" = "verbose";
        "typescript.tsserver.maxTsServerMemory" = 4096;
        #"typescript.disableAutomaticTypeAcquisition" = true;
        #"typescript.tsserver.useSeparateProcess" = true;
      };
    };
  };
}
