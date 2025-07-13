{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    # package = pkgs.vscodium; # I need some proprietary extensions unfortunately
    # This property will be used to generate settings.json
    # Note that many of the annoyance blockers are no longer needed after switching to vscodium
    # and instead act as noops. Investigate this
    profiles.default.userSettings = {
      # aesthetics
      "workbench.colorTheme" = "Ayu Mirage Bordered";
      "editor.fontFamily" = "'MesloLGS NF', 'Braille CC0', Menlo, Monaco, 'Courier New', monospace";
      "terminal.integrated.cursorStyle" = "line";
      # basic behavior
      "editor.formatOnSave" = false;
      "explorer.confirmDelete" = false;
      "explorer.autoReveal" = false;
      "explorer.confirmDragAndDrop" = false;
      "terminal.external.osxExec" = "iTerm2.app";
      # annoyances of various degrees
      "editor.accessibilitySupport" = "off";
      "workbench.startupEditor" = "none";
      "window.newWindowDimensions" = "maximized";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.showExitAlert" = false;
      "extensions.autoUpdate" = false;
      "workbench.remoteIndicator.showExtensionRecommendations" = false;
      "workbench.editor.empty.hint" = "hidden";
      # please do not enable ai features
      "chat.commandCenter.enabled" = false;
      "python.analysis.addHoverSummaries" = false;
      "notebook.experimental.generate" = false;
      # extension annoyances
      "direnv.restart.automatic" = true;
      # full chunky python LSP
      "python.analysis.inlayHints.callArgumentNames" = "partial";
      "python.analysis.inlayHints.functionReturnTypes" = true;
      "python.analysis.inlayHints.variableTypes" = true;
      "python.analysis.languageServerMode" = "full";
      "python.analysis.typeCheckingMode" = "standard";
      "python.analysis.typeEvaluation.deprecateTypingAliases" = true;
      "python.analysis.typeEvaluation.strictDictionaryInference" = true;
      "python.analysis.typeEvaluation.strictListInference" = true;
      # rust
      "rust-analyzer.check.command" = "clippy";
    };
    # =======================================================================
    # >>>                                                                 <<<
    # >>> DO NOT UPDATE VSCODE SETTINGS OR EXTENSIONS WHILE IT IS RUNNING <<<
    # >>>                                                                 <<<
    # =======================================================================
    # If you forget and get jumpscared by the default theme, follow these steps:
    # 1. Quit vscode
    # 2. Perform some action that touches the vscode configuration, eg.
    #    toggling some extensions or just updating your flake
    # 3. Relaunch
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      # basic
      teabyii.ayu
      # python
      ms-python.python
      ms-python.vscode-pylance
      ms-python.debugpy
      # jupyter
      ms-toolsai.jupyter
      # rust
      usernamehw.errorlens
      rust-lang.rust-analyzer
      tamasfe.even-better-toml
      # nix
      jnoortheen.nix-ide
      mkhl.direnv
    ];
  };
}