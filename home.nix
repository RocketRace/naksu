{ config, pkgs, ... }:

{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (
      let recipe = { python3, fetchFromGitHub }:
        with python3.pkgs;
        buildPythonApplication {
          name = "BeautifulDiscord";
          version = "0.2.0";
          pyproject = false;
          src = fetchFromGitHub {
            owner = "leovoel";
            repo = "BeautifulDiscord";
            rev = "9d6a0366990867f1b36c5f17b3fa3fd3430bdc97";
            hash = "sha256-UnJh39fzbPnXZmBHkAB3w+MeYw/Cpb+m9fpAVMVqM+M=";
          };
          buildInputs = [ pkgs.python3.pkgs.psutil ];
      };
      beautifuldiscord = pkgs.callPackage recipe {};
      env = pkgs.python3.buildEnv.override {
        extraLibs = [ beautifuldiscord ];
      };
      in pkgs.writeShellScriptBin "dinject" ''
        ${env}/bin/beautifuldiscord --css ${./discord/style.css}
      ''
    )
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "darwin-update" ''
    #   darwin-rebuild switch --flake ~/.config/nix
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".config/karabiner/karabiner.json".source = karabiner/karabiner.json;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # karabiner-elements should NOT be installed using nix for now. maybe it works in the future.
  # karabiner can't listen for symbolic links so we need to kickstart it
  # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/#about-symbolic-link
  home.file.".config/karabiner" = {
    source = ./karabiner;
    recursive = false;
    onChange = ''
      /bin/launchctl kickstart -k gui/`id -u`/org.pqrs.karabiner.karabiner_console_user_server
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/olivia/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.gh.enable = true;
  programs.zsh = {
    enable = true;
    shellAliases = {
      switch = ''cd ~/.config/nix &&
        git add . &&
        darwin-rebuild switch --show-trace --flake ~/.config/nix &&
        git commit --message "[Generation #] $1" &&
        GENERATION=$(darwin-rebuild --list-generations | tail -1 | grep -m 1 -o "[0-9]*" | head -1) &&
        git commit --amend --message "[Generation $GENERATION] $1" &&
        echo "Switched to generation $GENERATION"
      '';
    };
    # Initialize p10k configuration (took a while to find the config line because the wizard doesn't tell you)
    initExtra = ''
      [[ ! -f ${./p10k/.p10k.zsh} ]] || source ${./p10k/.p10k.zsh}
    '';
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
  programs.git = {
    enable = true;
    userName = "RocketRace";
    userEmail = "git@olivialta.cc";
    ignores = [ ".DS_Store" ];
    aliases = {
      alias = "!f () { if [ \"$#\" = 0 ]; then git config --get-regexp alias; else git config --get \"alias.$1\"; fi }; f";
      s = "status";
      a = "! git add . && git status";
      c = "commit";
      cm = "commit --message";
      cam = "commit --amend --message";
      can = "commit --amend --no-edit";
      acm = "! git add . && git commit --message";
      acan = "!git add . && git commit --amend --no-edit";
      dc = "diff --cached";
      dh = "!f() { git diff \"head~$1\"; }; f";
      cd = "checkout";
      pf = "pull --ff-only";
      spa = "! git stash pop && git add .";
      lg = "! git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
    };
  };
  programs.vscode = {
    enable = true;
    # This property will be used to generate settings.json
    userSettings = {
      # aesthetics
      "workbench.colorTheme" = "Ayu Mirage Bordered";
      "editor.fontFamily" = "'MesloLGS NF', 'Braille CC0', Menlo, Monaco, 'Courier New', monospace";
      "workbench.iconTheme" = "helium-icon-theme";
      "helium-icon-theme.opacity" = 0.5;
      "terminal.integrated.cursorStyle" = "line";
      # basic behavior
      "editor.formatOnSave" = false;
      "explorer.confirmDelete" = false;
      "explorer.autoReveal" = false;
      "explorer.confirmDragAndDrop" = false;
      "terminal.external.osxExec" = "iTerm";
      # annoyances of various degrees
      "editor.accessibilitySupport" = "off";
      "workbench.startupEditor" = "none";
      "window.newWindowDimensions" = "maximized";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.showExitAlert" = false;
      "chat.commandCenter.enabled" = false;
      "extensions.autoUpdate" = false;
      "workbench.remoteIndicator.showExtensionRecommendations" = false;
      # extension annoyances
      "direnv.restart.automatic" = true;
    };
    extensions = with pkgs.vscode-marketplace; [
      jnoortheen.nix-ide
      teabyii.ayu
      helgardrichard.helium-icon-theme
      ms-python.python
      usernamehw.errorlens
      rust-lang.rust-analyzer
      mkhl.direnv
    ];
  };
  programs.firefox = {
    enable = true;
    # IMPORTANT: use a package provided by the overlay (ends with `-bin`)
    package = pkgs.firefox-bin;
  };
  # custom fonts and keylayouts need to go through lower level mechanisms provided by macos
  # jank as hell tbh
  home.file."Library/Fonts/Symlinks" = {
    enable = true;
    source = ./fonts;
    recursive = true;
    onChange = ''
      cd ~/Library/Fonts
      rm -rf Custom
      mkdir Custom
      cp -Lr Symlinks/* Custom
    '';
  };
  # tasty nix develop
  programs.direnv = {
    enable = true;
  };
  home.file."Library/Application Support/discord/settings.json" = {
    enable = true;
    text = ''
      {
        "chromiumSwitches": {},
        "IS_MAXIMIZED": true,
        "IS_MINIMIZED": false,
        "DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING": true
      }
    '';
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
